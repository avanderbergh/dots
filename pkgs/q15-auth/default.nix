{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "q15-auth";
  version = "2026.3.16-3f7c4d5";

  src = fetchFromGitHub {
    owner = "q15co";
    repo = "q15";
    rev = "v${version}";
    hash = "sha256-Jazp1BrxxygiknJC802z1hNXTvLCqFi5QsSETB6HfoU=";
  };

  modRoot = "systems/agent";
  subPackages = ["cmd/q15-auth"];

  env.GOWORK = "off";

  vendorHash = "sha256-imanWT9f97TOL0UuHlKKzdDXEbRrjlKlJrqblFdRCds=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Interactive bootstrap tool for generating and inspecting q15 auth.json";
    homepage = "https://github.com/q15co/q15";
    license = licenses.mit;
    mainProgram = "q15-auth";
    platforms = platforms.unix;
  };
}
