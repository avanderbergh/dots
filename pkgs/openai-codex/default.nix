{
  lib,
  buildNodePackage,
  fetchFromNpm,
  ...
}:
buildNodePackage rec {
  name = "openai-codex";
  packageName = "@openai/codex";
  version = "0.1.2504161551";

  src = fetchFromNpm {
    inherit packageName version;
    sha256 = "118yxgnyi7sqzljfwkz0imdcdz1hzl0d75shib6qwj6608n48948";
  };

  meta = {
    description = "Official OpenAI Codex client";
    homepage = "https://www.npmjs.com/package/@openai/codex";
    license = lib.licenses.mit;
  };
}
