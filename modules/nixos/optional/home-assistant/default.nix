{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "accuweather"
      "esphome"
      "ffmpeg"
      "github"
      "hue"
      "met"
      "radio_browser"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
    configWritable = true;
  };
}
