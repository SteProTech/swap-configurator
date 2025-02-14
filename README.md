# Swap Configurator 🔄

[![GitHub Stars](https://img.shields.io/github/stars/SteProTech/swap-configurator?style=for-the-badge)](https://github.com/SteProTech/swap-configurator/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A professional-grade script for configuring swap space on Linux servers with automatic swappiness optimization.

## Features ✨
- Automatic swap file creation/removal
- Swappiness optimization (10 by default)
- Disk space validation
- Persistent configuration
- Color-coded UI
- Safety checks
- Systemd compatibility

## Installation ⚡

### Quick Install (via curl):
```bash
curl -sSL https://raw.githubusercontent.com/yourusername/swap-configurator/main/src/swap-manager.sh | sudo bash
```

### Manual Install:
```bash
wget https://raw.githubusercontent.com/SteProTech/swap-configurator/main/src/swap-manager.sh
chmod +x swap-manager.sh
sudo ./swap-manager.sh
```

## Usage 🚀
Run the script with root privileges:
```bash
sudo ./swap-manager.sh
```

Follow the on-screen prompts to:
1. Remove existing swap (if any)
2. Specify swap size (in GB)
3. Automatically configure swappiness

## Customization 🔧
You can customize the script by editing these variables:
```bash
SWAP_FILE="/swapfile"          # Swap file path
DESIRED_SWAPPINESS=10          # Recommended: 10-30 for servers
MIN_SWAP_SIZE=1                # Minimum swap size (GB)
MAX_SWAP_SIZE=128              # Maximum swap size (GB)
```

## License 📄
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Best Practices 📘
For recommendations on swap sizing and performance tuning, check out the [Best Practices Guide](docs/BEST-PRACTICES.md).

## Code of Conduct
Please review our [Code of Conduct](CODE_OF_CONDUCT.md) to ensure a welcoming and inclusive community.

## CI/CD Status
[![ShellCheck Validation](https://github.com/SteProTech/swap-configurator/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/SteProTech/swap-configurator/actions/workflows/shellcheck.yml)

## Support
If you find this project useful, please consider giving it a [⭐](https://github.com/SteProTech/swap-configurator) on GitHub!
