# Local disk backup

The host policy lives in `hosts/hermes/backup.nix`. Btrbk copies read-only
snapshots of the NVMe's `home` and `persist` subvolumes to the existing encrypted
HDD every night at 03:00, local time. A missed run is caught up when the timer
starts. No disk is formatted and existing HDD files are left in place.

The HDD retains daily backups for seven days, weekly backups for four weeks,
and monthly backups for three months, plus the latest backup. These are retention
windows, not guaranteed counts if runs were missed. The NVMe keeps the latest
source snapshot needed for incremental transfers. Each completed HDD snapshot
is independently usable; restoring it does not require the NVMe or older backups.

## Avoiding allocation exhaustion

Btrfs allocates disk space separately for file data and metadata. `df` alone
does not show whether there is room to allocate more metadata chunks, and a
balance also needs working space. A nearly full *allocated metadata area* is
not by itself a crisis if substantial device space remains unallocated.

The `backup-space-check` service checks both disks hourly and before each backup.
It requires at least **20 GiB of unallocated space and 20% free space** on each
filesystem. These are conservative operating margins, not a guarantee against
ENOSPC. Below either threshold, the service fails visibly in `systemctl --failed`
and blocks the dump and new backup snapshots. Existing backups remain intact.
It does not stop unrelated applications writing data or interrupt a running
transfer, so rapid growth can still exhaust space between checks.

Only the latest source snapshot is normally retained on the NVMe; older history
lives on the HDD. Even one snapshot can pin substantial old data after container
or Nix garbage collection. Failed transfers may also leave snapshots needed for
retry; investigate failures rather than allowing them to accumulate.

If a space check fails, inspect allocation and snapshot retention before deleting
anything. A failed check means **new backups are paused** and needs attention:

```bash
sudo journalctl -u backup-space-check -n 100 --no-pager
sudo btrfs filesystem usage -T /home
sudo btrfs filesystem usage -T "$backup_home/hdd"
```

Scrub checks data integrity; it does not reclaim allocation space. This setup
does not run automatic balances or filesystem repairs. Low-usage filtered
balances can help some allocation problems, but require diagnosis and sufficient
headroom; a full balance is not a universal fix. If the NVMe becomes read-only
or unmountable, recover from the separate HDD instead of depending on repair of
the damaged filesystem. See the [Btrfs ENOSPC explanation](https://btrfs.readthedocs.io/en/latest/trouble-index.html).

## What is covered

- All user homes, including the bot account, q15 memory, workspaces, configuration,
  and rootless Podman volumes (including Qdrant).
- All ordinary files in `/persist`, including SSH/SOPS keys, account password
  hashes, Secure Boot keys, network identity, and persistent service data.
- A fresh `pg_dumpall` in `/persist/backup/postgresql/all.sql.gz`. The snapshot
  job requires the dump to succeed first, including for manual backup runs.

Snapshots capture live applications in a state similar to an unexpected power
loss. They are not a coordinated application shutdown. PostgreSQL additionally
has the logical dump for database recovery or migration. Stop affected services
before restoring their files; validate databases after recovery.

Btrfs snapshots do not traverse other mounts or nested subvolumes. This keeps
the HDD backup from backing itself up even though it is mounted inside a home
directory. The SSD and existing HDD media are **not backed up** by this job.
Neither are `/nix`, `/boot`, logs, swap, or disposable root state. Jellyfin's
currently unpersisted `/var/lib/jellyfin` is outside this backup too.

Docker's Btrfs image/container-layer subvolumes are not included. At setup time
Docker had no running containers or named volumes. After disk recovery, recreate
Docker's image/layer store rather than relying on the partial store metadata in
`/persist`; restore application data separately if you add Docker workloads.
Do not create nested subvolumes for important data without extending the backup
configuration. Rootless Podman's current overlay store is ordinary home data.

The backup directory is root-only. Its encryption is the HDD's existing LUKS
encryption, so keep its unlock passphrase somewhere accessible if the NVMe dies.
There is no new backup password. A local copy covers one drive failing; it does
not cover loss of the whole machine or an attacker with root access.

## Enable and make the first backup

Run these commands in **Bash on the target machine**, from a checkout containing
the change. Read the hostname and account from the machine and configuration:

```bash
backup_host=$(hostname --short)
test -f "hosts/$backup_host/default.nix"
rg "nixosHosts\.$backup_host" "hosts/$backup_host/default.nix"
backup_owner=$(nix eval --raw ".#nixosConfigurations.${backup_host}.config.local.users.ownerName")
backup_home=$(nix eval --raw ".#nixosConfigurations.${backup_host}.config.users.users.${backup_owner}.home")
backup_dir="$backup_home/hdd/backups/$backup_host"

sudo nixos-rebuild switch --flake ".#$backup_host"
sudo systemctl start btrbk-local.service
sudo systemctl status btrbk-local.service
sudo journalctl -u postgresqlBackup -u btrbk-local -n 100 --no-pager
sudo btrbk -c /etc/btrbk/local.conf list latest
systemctl list-timers btrbk-local.timer
```

The first run copies all included data and can take hours. Later runs send
changed extents. Caches and rootless container images are included to keep this
a complete subvolume copy; retained changes consume space. A full disk causes a
failed backup, not automatic deletion of unrelated data. Check free space on
both NVMe and HDD periodically.

Before accepting the first backup, check the actual nested subvolume layout:

```bash
sudo btrfs subvolume list -o /home
sudo btrfs subvolume list -o /persist
```

Important data in any listed nested subvolume needs its own configured source.
The expected Docker layer subvolumes are rebuildable. Do not count snapshots on
the NVMe as protection from NVMe failure: the HDD copies must have completed.

## Check and test a restore

Use the variables from the setup section. This selects the latest home snapshot,
copies the q15 Compose file into a new temporary directory, and compares it with
the backed-up file without overwriting the live stack:

```bash
home_snapshot=$(sudo find "$backup_dir" -mindepth 1 -maxdepth 1 -type d -name 'home.*' | LC_ALL=C sort | tail -n 1)
persist_snapshot=$(sudo find "$backup_dir" -mindepth 1 -maxdepth 1 -type d -name 'persist.*' | LC_ALL=C sort | tail -n 1)
test -n "$home_snapshot" && test -n "$persist_snapshot"
restore_dir=$(mktemp -d)
sudo cp -a "$home_snapshot/$backup_owner/.config/q15/stacks/jared/compose.yaml" "$restore_dir/compose.yaml"
sudo cmp "$home_snapshot/$backup_owner/.config/q15/stacks/jared/compose.yaml" "$restore_dir/compose.yaml"
sudo gzip -t "$persist_snapshot/backup/postgresql/all.sql.gz"
printf 'Restored test file: %s/compose.yaml\n' "$restore_dir"
```

`cmp` and `gzip -t` print nothing on success. This proves the selected files can
be read and copied; it is not a full application recovery test. Inspect the
backup for your important data, particularly q15 memory and Qdrant's volume.

Routine checks:

```bash
systemctl --failed
sudo journalctl -u backup-space-check --since '1 day ago' --no-pager
sudo journalctl -u btrbk-local --since '7 days ago' --no-pager
sudo btrbk -c /etc/btrbk/local.conf list latest
df -h /home "$backup_home/hdd"
sudo btrfs scrub status /home "$backup_home/hdd"
sudo journalctl -u smartd --since '7 days ago' --no-pager
```

Monthly scrubs read and verify Btrfs checksums; SMART monitoring reports disk
health in the journal. Neither guarantees warning before a disk fails, and
single-copy data corruption cannot necessarily be repaired by a scrub. There
is no external alert delivery configured; check failed units and backup dates.

## If the NVMe fails

1. Boot a NixOS installer, unlock the surviving HDD with its LUKS passphrase,
   and mount it read-only. `lsblk -f` identifies the disks; the configured LUKS
   labels and subvolume layout are in the host hardware file and
   `modules/nixos/ephemeral-btrfs.nix`. Do not format the backup disk.
2. Prepare the replacement NVMe with the same encrypted Btrfs layout and an EFI
   partition. Mount its top-level Btrfs filesystem at `/mnt/new-system`. Keep
   services stopped throughout recovery. Set `backup_dir` to the backup directory
   on the surviving HDD and select a completed `home.*`/`persist.*` pair from the
   same successful run.
3. Transfer those snapshots onto the new NVMe, then make writable `home` and
   `persist` subvolumes. The following assumes the replacement filesystem has
   no subvolumes with those names yet. Substitute the selected snapshot paths:

   ```bash
   # Bash; choose the two paths before running this block.
   home_snapshot="$backup_dir/home.SELECTED_TIMESTAMP"
   persist_snapshot="$backup_dir/persist.SELECTED_TIMESTAMP"
   set -o pipefail
   sudo mkdir -p /mnt/new-system/received
   sudo btrfs send "$home_snapshot" | sudo btrfs receive /mnt/new-system/received
   sudo btrfs send "$persist_snapshot" | sudo btrfs receive /mnt/new-system/received
   sudo btrfs subvolume snapshot "/mnt/new-system/received/$(basename "$home_snapshot")" /mnt/new-system/home
   sudo btrfs subvolume snapshot "/mnt/new-system/received/$(basename "$persist_snapshot")" /mnt/new-system/persist
   ```

4. Create the remaining empty subvolumes (`root-blank`, `root`, `nix`, `log`,
   `swap`) and mount the layout for installation. `root-blank` must stay empty:
   the boot process replaces `root` with a snapshot of it. Reinstall from the
   restored flake using the original host's explicit output. Preserve the
   restored `/persist` identity and Secure Boot keys. Do not activate the
   desktop or container services until the data mounts are in place.
5. Start and verify the applications. Prefer the SQL dump if PostgreSQL needs
   rebuilding or its major version changed. Restore Qdrant's complete storage
   directory, not individual collection files; verify collections and q15
   memory before considering recovery complete.

The snapshot transfer avoids copying files one by one and preserves ownership,
permissions, ACLs, and extended attributes. These backups are data recovery,
not a bootable clone; replacement-disk preparation and NixOS installation are
still required. Keep this guide available on another machine.

References: [Btrbk retention and transfers](https://digint.ch/btrbk/doc/btrbk.conf.5.html),
[Btrfs snapshot boundaries](https://btrfs.readthedocs.io/en/latest/btrfs-subvolume.html),
[PostgreSQL filesystem recovery](https://www.postgresql.org/docs/17/backup-file.html).
