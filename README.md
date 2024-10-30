# NixOS Configurations

Welcome to my NixOS configurations repository! This is where I manage the setup for my personal machines using Nix Flakes.

## Hosts

### Zoidberg

- **Hostname**: `zoidberg`
- **Configuration File**: [./hosts/zoidberg](./hosts/zoidberg)
- **Machine**: Dell XPS 17 9700
- **Specs**: 32GB RAM | 1TB SSD

### Hermes

- **Hostname**: `hermes`
- **Configuration File**: [./hosts/hermes](./hosts/hermes)
- **Machine**: HP Pavilion TG01-0004ng
- **Specs**: Ryzen 7 3700X | 16GB RAM | 1TB + 512GB SSD | RTX 2060, 8GB

### Farnsworth

- **Hostname**: `farnsworth`
- **Configuration File**: [./hosts/farnsworth](./hosts/farnsworth)
- **Machine**: Fujitsu Futro S720

Feel free to explore the configurations and see how everything is set up!

## Notes

### Import GPG Keys

```sh
gpg --keyserver keyserver.ubuntu.com --recv-keys 741eda0a1f942978d0e612ed938036d74671d8d5
```
