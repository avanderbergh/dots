{
  writeShellApplication,
  nodejs_24,
}:
writeShellApplication {
  name = "pi";
  runtimeInputs = [nodejs_24];
  text = ''
    exec npx --yes @mariozechner/pi-coding-agent "$@"
  '';
}
