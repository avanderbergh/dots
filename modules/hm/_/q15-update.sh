#!/usr/bin/env bash
set -Eeuo pipefail

umask 077

stack_dir="${Q15_STACK_DIR:-${HOME}/.config/q15/stacks/jared}"
service_unit="${Q15_SERVICE_UNIT:-q15.service}"
release_repository="${Q15_RELEASE_REPOSITORY:-ghcr.io/q15co/q15-agent}"
health_timeout="${Q15_UPDATE_HEALTH_TIMEOUT:-180}"
env_file="${stack_dir}/.env"
compose_file="${stack_dir}/compose.yaml"
previous_env="${stack_dir}/.env.previous"
lock_file="${stack_dir}/.release-update.lock"

agent_repository="ghcr.io/q15co/q15-agent"
exec_repository="ghcr.io/q15co/q15-exec"
proxy_repository="ghcr.io/q15co/q15-proxy"
temporary_dir=""

cleanup() {
	if [[ -n ${temporary_dir} && -d ${temporary_dir} && ${temporary_dir} == "${stack_dir}"/.release-update.* ]]; then
		rm -r -- "${temporary_dir}"
	fi
}

trap cleanup EXIT

log() {
	printf 'q15-update: %s\n' "$*" >&2
}

die() {
	log "error: $*"
	exit 1
}

usage() {
	cat <<'EOF'
Usage:
  q15-update                 Update to the latest successful main release
  q15-update <full-sha>      Update or roll back to one immutable release
  q15-update --dry-run [sha] Resolve and print a release without changing it
  q15-update --rollback      Swap back to the previously deployed release
  q15-update --status        Show configured and running image digests
EOF
}

require_command() {
	command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

read_env_value() {
	local key="$1"
	local source_file="$2"

	awk -v prefix="${key}=" 'index($0, prefix) == 1 { value = substr($0, length(prefix) + 1) } END { print value }' "${source_file}"
}

validate_digest() {
	[[ $1 =~ ^sha256:[0-9a-f]{64}$ ]] || die "invalid OCI digest: $1"
}

validate_revision() {
	[[ $1 =~ ^[0-9a-f]{40}$ ]] || die "invalid release revision: $1"
}

validate_stack_files() {
	[[ -f ${compose_file} ]] || die "missing Compose file: ${compose_file}"
	[[ -f ${env_file} ]] || die "missing environment file: ${env_file}"
	grep -Fq "\${Q15_AGENT_IMAGE" "${compose_file}" || die "compose.yaml does not use Q15_AGENT_IMAGE"
	grep -Fq "\${Q15_EXEC_IMAGE" "${compose_file}" || die "compose.yaml does not use Q15_EXEC_IMAGE"
	grep -Fq "\${Q15_PROXY_IMAGE" "${compose_file}" || die "compose.yaml does not use Q15_PROXY_IMAGE"
}

release_tag_for() {
	local requested_revision="${1:-}"

	if [[ -z ${requested_revision} ]]; then
		printf 'release-main\n'
		return
	fi

	requested_revision="${requested_revision#release-}"
	validate_revision "${requested_revision}"
	printf 'release-%s\n' "${requested_revision}"
}

resolve_release() {
	local tag="$1"
	local raw_file="$2"
	local release_ref="${release_repository}:${tag}"

	log "resolving ${release_ref}"
	skopeo inspect --raw "docker://${release_ref}" >"${raw_file}"

	local schema
	local revision
	local agent_digest
	local exec_digest
	local proxy_digest
	schema="$(jq -er '.annotations["io.q15.release.schema"]' "${raw_file}")"
	revision="$(jq -er '.annotations["io.q15.release.revision"]' "${raw_file}")"
	agent_digest="$(jq -er '.annotations["io.q15.release.agent"]' "${raw_file}")"
	exec_digest="$(jq -er '.annotations["io.q15.release.exec"]' "${raw_file}")"
	proxy_digest="$(jq -er '.annotations["io.q15.release.proxy"]' "${raw_file}")"

	[[ ${schema} == 1 ]] || die "unsupported release schema: ${schema}"
	validate_revision "${revision}"
	validate_digest "${agent_digest}"
	validate_digest "${exec_digest}"
	validate_digest "${proxy_digest}"

	if [[ ${tag} != release-main && ${tag} != "release-${revision}" ]]; then
		die "release tag and embedded revision do not match"
	fi

	RESOLVED_REVISION="${revision}"
	RESOLVED_AGENT_IMAGE="${agent_repository}@${agent_digest}"
	RESOLVED_EXEC_IMAGE="${exec_repository}@${exec_digest}"
	RESOLVED_PROXY_IMAGE="${proxy_repository}@${proxy_digest}"
}

render_env() {
	local source_file="$1"
	local destination="$2"
	local revision="$3"
	local agent_image="$4"
	local exec_image="$5"
	local proxy_image="$6"

	awk '
    !/^Q15_IMAGE_TAG=/ &&
    !/^Q15_(AGENT|EXEC|PROXY)_TAG=/ &&
    !/^Q15_(AGENT|EXEC|PROXY)_IMAGE=/ &&
    !/^Q15_RELEASE_REVISION=/ {
      lines[++count] = $0
    }
    END {
      while (count > 0 && lines[count] ~ /^[[:space:]]*$/) {
        count--
      }
      for (line = 1; line <= count; line++) {
        print lines[line]
      }
    }
  ' "${source_file}" >"${destination}"

	if [[ -s ${destination} ]]; then
		printf '\n' >>"${destination}"
	fi
	{
		printf 'Q15_RELEASE_REVISION=%s\n' "${revision}"
		printf 'Q15_AGENT_IMAGE=%s\n' "${agent_image}"
		printf 'Q15_EXEC_IMAGE=%s\n' "${exec_image}"
		printf 'Q15_PROXY_IMAGE=%s\n' "${proxy_image}"
	} >>"${destination}"
	chmod --reference="${source_file}" "${destination}"
}

images_match_env() {
	local source_file="$1"
	local agent_image="$2"
	local exec_image="$3"
	local proxy_image="$4"

	[[ $(read_env_value Q15_AGENT_IMAGE "${source_file}") == "${agent_image}" ]] &&
		[[ $(read_env_value Q15_EXEC_IMAGE "${source_file}") == "${exec_image}" ]] &&
		[[ $(read_env_value Q15_PROXY_IMAGE "${source_file}") == "${proxy_image}" ]]
}

prepull_images() {
	local image

	for image in "$@"; do
		log "ensuring ${image} is available locally"
		podman pull --policy missing "${image}" >/dev/null
	done
}

reconcile_stack() {
	if systemctl --user is-active --quiet "${service_unit}"; then
		log "reconciling ${service_unit}"
		systemctl --user reload "${service_unit}"
	else
		log "starting ${service_unit}"
		systemctl --user start "${service_unit}"
	fi
}

wait_for_stack() {
	local expected_agent_image="$1"
	local expected_exec_image="$2"
	local expected_proxy_image="$3"
	local expected_agent_id
	local expected_exec_id
	local expected_proxy_id
	local deadline=$((SECONDS + health_timeout))
	local container
	local expected_image
	local expected_id
	local inspect_json
	local actual_id
	local all_ready
	expected_agent_id="$(podman image inspect "${expected_agent_image}" --format '{{.Id}}')"
	expected_exec_id="$(podman image inspect "${expected_exec_image}" --format '{{.Id}}')"
	expected_proxy_id="$(podman image inspect "${expected_proxy_image}" --format '{{.Id}}')"

	while ((SECONDS < deadline)); do
		all_ready=true
		for container in q15-agent q15-exec q15-proxy; do
			case "${container}" in
			q15-agent)
				expected_image="${expected_agent_image}"
				expected_id="${expected_agent_id}"
				;;
			q15-exec)
				expected_image="${expected_exec_image}"
				expected_id="${expected_exec_id}"
				;;
			q15-proxy)
				expected_image="${expected_proxy_image}"
				expected_id="${expected_proxy_id}"
				;;
			esac

			if ! inspect_json="$(podman inspect "${container}" 2>/dev/null)"; then
				all_ready=false
				continue
			fi
			if ! jq -e '.[0].State.Running == true and .[0].State.Health.Status == "healthy"' <<<"${inspect_json}" >/dev/null; then
				all_ready=false
				continue
			fi

			actual_id="$(jq -r '.[0].Image // empty' <<<"${inspect_json}")"
			if [[ ${actual_id} != "${expected_id}" ]]; then
				log "${container} is not yet running ${expected_image}"
				all_ready=false
			fi
		done

		if [[ ${all_ready} == true ]]; then
			return 0
		fi
		sleep 2
	done

	log "stack did not become healthy with the expected digests within ${health_timeout}s"
	podman ps --format '{{.Names}} | {{.Image}} | {{.Status}}' >&2 || true
	return 1
}

digest_from_image_ref() {
	local image_ref="$1"
	local digest="${image_ref##*@}"

	validate_digest "${digest}"
	printf '%s\n' "${digest}"
}

install_env() {
	local source_file="$1"
	local destination_tmp

	destination_tmp="$(mktemp "${stack_dir}/.env.install.XXXXXX")"
	cp --preserve=mode "${source_file}" "${destination_tmp}"
	mv -f "${destination_tmp}" "${env_file}"
}

normalize_current_env() {
	local current_agent
	local current_exec
	local current_proxy
	local normalized_env
	local inspect_json
	local agent_digest
	local exec_digest
	local proxy_digest

	current_agent="$(read_env_value Q15_AGENT_IMAGE "${env_file}")"
	current_exec="$(read_env_value Q15_EXEC_IMAGE "${env_file}")"
	current_proxy="$(read_env_value Q15_PROXY_IMAGE "${env_file}")"
	if [[ -n ${current_agent} && -n ${current_exec} && -n ${current_proxy} ]]; then
		digest_from_image_ref "${current_agent}" >/dev/null
		digest_from_image_ref "${current_exec}" >/dev/null
		digest_from_image_ref "${current_proxy}" >/dev/null
		return
	fi

	log "migrating the current running stack to digest-pinned image references"
	inspect_json="$(podman inspect q15-agent)"
	agent_digest="$(jq -er '.[0].ImageDigest' <<<"${inspect_json}")"
	inspect_json="$(podman inspect q15-exec)"
	exec_digest="$(jq -er '.[0].ImageDigest' <<<"${inspect_json}")"
	inspect_json="$(podman inspect q15-proxy)"
	proxy_digest="$(jq -er '.[0].ImageDigest' <<<"${inspect_json}")"
	validate_digest "${agent_digest}"
	validate_digest "${exec_digest}"
	validate_digest "${proxy_digest}"

	normalized_env="$(mktemp "${stack_dir}/.env.normalized.XXXXXX")"
	render_env \
		"${env_file}" \
		"${normalized_env}" \
		"unrecorded" \
		"${agent_repository}@${agent_digest}" \
		"${exec_repository}@${exec_digest}" \
		"${proxy_repository}@${proxy_digest}"
	install_env "${normalized_env}"
	rm -f "${normalized_env}"
}

show_status() {
	local revision
	local container
	local configured
	local inspect_json

	revision="$(read_env_value Q15_RELEASE_REVISION "${env_file}")"
	printf 'Release: %s\n' "${revision:-unrecorded}"
	for container in agent exec proxy; do
		configured="$(read_env_value "Q15_${container^^}_IMAGE" "${env_file}")"
		if inspect_json="$(podman inspect "q15-${container}" 2>/dev/null)"; then
			printf '%-5s configured=%s\n      running=%s health=%s\n' \
				"${container}" \
				"${configured:-unset}" \
				"$(jq -r '.[0].ImageName + "@" + .[0].ImageDigest' <<<"${inspect_json}")" \
				"$(jq -r '.[0].State.Health.Status // .[0].State.Status' <<<"${inspect_json}")"
		else
			printf '%-5s configured=%s\n      running=absent\n' "${container}" "${configured:-unset}"
		fi
	done
}

rollback() {
	[[ -f ${previous_env} ]] || die "no previous release is recorded"

	local rollback_agent
	local rollback_exec
	local rollback_proxy
	local current_snapshot

	rollback_agent="$(read_env_value Q15_AGENT_IMAGE "${previous_env}")"
	rollback_exec="$(read_env_value Q15_EXEC_IMAGE "${previous_env}")"
	rollback_proxy="$(read_env_value Q15_PROXY_IMAGE "${previous_env}")"
	[[ -n ${rollback_agent} && -n ${rollback_exec} && -n ${rollback_proxy} ]] || die "previous release is not digest-pinned"
	digest_from_image_ref "${rollback_agent}" >/dev/null
	digest_from_image_ref "${rollback_exec}" >/dev/null
	digest_from_image_ref "${rollback_proxy}" >/dev/null

	prepull_images "${rollback_agent}" "${rollback_exec}" "${rollback_proxy}"
	current_snapshot="$(mktemp "${stack_dir}/.env.current.XXXXXX")"
	cp --preserve=mode "${env_file}" "${current_snapshot}"
	install_env "${previous_env}"

	if reconcile_stack && wait_for_stack "${rollback_agent}" "${rollback_exec}" "${rollback_proxy}"; then
		install -m 600 "${current_snapshot}" "${previous_env}"
		rm -f "${current_snapshot}"
		log "rollback completed"
		show_status
		return
	fi

	log "rollback failed; restoring the release that was active before the attempt"
	install_env "${current_snapshot}"
	rm -f "${current_snapshot}"
	reconcile_stack || true
	die "rollback failed"
}

main() {
	local mode=update
	local requested_revision=""

	while [[ $# -gt 0 ]]; do
		case "$1" in
		--dry-run)
			mode=dry-run
			;;
		--rollback)
			mode=rollback
			;;
		--status)
			mode=status
			;;
		--help | -h)
			usage
			return
			;;
		-*)
			die "unknown option: $1"
			;;
		*)
			[[ -z ${requested_revision} ]] || die "only one release revision may be specified"
			requested_revision="$1"
			;;
		esac
		shift
	done

	[[ ${health_timeout} =~ ^[1-9][0-9]*$ ]] || die "Q15_UPDATE_HEALTH_TIMEOUT must be a positive integer"
	for command in awk flock grep jq mktemp podman skopeo systemctl; do
		require_command "${command}"
	done

	validate_stack_files
	exec 9>"${lock_file}"
	flock --exclusive 9

	case "${mode}" in
	status)
		[[ -z ${requested_revision} ]] || die "--status does not accept a release revision"
		show_status
		return
		;;
	rollback)
		[[ -z ${requested_revision} ]] || die "--rollback does not accept a release revision"
		normalize_current_env
		rollback
		return
		;;
	esac

	local release_tag
	local release_raw
	local desired_env
	local current_snapshot
	release_tag="$(release_tag_for "${requested_revision}")"
	temporary_dir="$(mktemp -d "${stack_dir}/.release-update.XXXXXX")"
	release_raw="${temporary_dir}/release.json"
	desired_env="${temporary_dir}/env"
	resolve_release "${release_tag}" "${release_raw}"
	render_env \
		"${env_file}" \
		"${desired_env}" \
		"${RESOLVED_REVISION}" \
		"${RESOLVED_AGENT_IMAGE}" \
		"${RESOLVED_EXEC_IMAGE}" \
		"${RESOLVED_PROXY_IMAGE}"

	printf 'Release: %s\nAgent:   %s\nExec:    %s\nProxy:   %s\n' \
		"${RESOLVED_REVISION}" \
		"${RESOLVED_AGENT_IMAGE}" \
		"${RESOLVED_EXEC_IMAGE}" \
		"${RESOLVED_PROXY_IMAGE}"
	if [[ ${mode} == dry-run ]]; then
		return
	fi

	normalize_current_env

	if images_match_env "${env_file}" "${RESOLVED_AGENT_IMAGE}" "${RESOLVED_EXEC_IMAGE}" "${RESOLVED_PROXY_IMAGE}"; then
		install_env "${desired_env}"
		log "release metadata updated; image digests were already current"
		show_status
		return
	fi

	prepull_images "${RESOLVED_AGENT_IMAGE}" "${RESOLVED_EXEC_IMAGE}" "${RESOLVED_PROXY_IMAGE}"
	digest_from_image_ref "${RESOLVED_AGENT_IMAGE}" >/dev/null
	digest_from_image_ref "${RESOLVED_EXEC_IMAGE}" >/dev/null
	digest_from_image_ref "${RESOLVED_PROXY_IMAGE}" >/dev/null
	current_snapshot="${temporary_dir}/env.current"
	cp --preserve=mode "${env_file}" "${current_snapshot}"
	install -m 600 "${current_snapshot}" "${previous_env}"
	install_env "${desired_env}"

	if reconcile_stack && wait_for_stack "${RESOLVED_AGENT_IMAGE}" "${RESOLVED_EXEC_IMAGE}" "${RESOLVED_PROXY_IMAGE}"; then
		log "release ${RESOLVED_REVISION} is healthy"
		show_status
		return
	fi

	log "release failed; restoring the previous image lock"
	install_env "${current_snapshot}"
	if reconcile_stack; then
		local previous_agent
		local previous_exec
		local previous_proxy
		previous_agent="$(read_env_value Q15_AGENT_IMAGE "${current_snapshot}")"
		previous_exec="$(read_env_value Q15_EXEC_IMAGE "${current_snapshot}")"
		previous_proxy="$(read_env_value Q15_PROXY_IMAGE "${current_snapshot}")"
		digest_from_image_ref "${previous_agent}" >/dev/null
		digest_from_image_ref "${previous_exec}" >/dev/null
		digest_from_image_ref "${previous_proxy}" >/dev/null
		wait_for_stack "${previous_agent}" "${previous_exec}" "${previous_proxy}" || true
	fi
	die "release failed and was rolled back"
}

main "$@"
