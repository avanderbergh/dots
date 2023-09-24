{
  config,
  pkgs,
  ...
}: {
  users = {
    mutableUsers = false;
    users = {
      avanderbergh = {
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "dialout"];
        hashedPasswordFile = "/persist/passwords/avanderbergh";
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC70ed167oK/Ka8JTMCLF3mH+kUO7SRirjkFRu4zRgQBhTVTVwuHm8TLi0Jzs+PBbTBXDlomSTS5ft6hs4xt+VQagRh2mrekfPGbAeE9NBWhHhujkMu4jT9q4nS6qTzaw9m+LiwXpZz0SP6SV9jFL78TTFUqtSAF2qSHIOHDVJFYra2Co0UHeJv1zYKx3bVJ5KXOXzP7jgNKDk6o5xtoS0owL3jxXPdpbr1qV3jAQik5acH0NYaNgbgwVoHEMJ14O5GzH705wTZR0ljW1Ysl+/tqY0mRhwMneyPp6tyzgF56UMSjfTCJCCGPwJxYnhEOm1D3tB2f2ZARmcLCknWF1LzCCKKyR5qULv3ffQ8U+3R56051QHh9Qjt+5dDWuRnj1m2Zd2WbfUl0ZtejKWTPzXLE6ABb9SX7eNbFonK+3mRLLvrFd+pFIAKmDORVPVBhy/na/1C//HotmzlAQ4nwRVGzXVvjiZIrEHfdbrCBQO3aYFIFSWqwckRuO3fjya4N8lVigq+LqavrcuGdBdg2/Y+HCvSzQxBKPgzGdjPACpIraQHG7LwigCRnDNB4myIoni40bdR7OHh3ZL4315mxscbhyjdKuBuMQI8U4An059MR29AqLU8KplSooPSEs1ERJ8XKnJeFK16W4s08+zVExJNDJm8dXAQJXbgIPKPepO0Mw== cardno:13_075_747"
        ];
      };
    };
  };
}
