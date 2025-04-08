# WarpFactor

![Warp Factor Banner](https://img.shields.io/badge/WarpFactor-v1.0-blue)
![macOS](https://img.shields.io/badge/macOS-Monterey%20%7C%20Ventura%20%7C%20Sonoma-success)
![License](https://img.shields.io/badge/license-MIT%20with%20Churchman%20Rider%20I-green) ![Copyright](https://img.shields.io/badge/Copyright-To%20Tech%20and%20Back%2C%20LTD.-blue)

## 🚀 Overview

WarpFactor is a system optimization utility designed specifically for the [Warp Terminal](https://www.warp.dev/) application on macOS. It provides functions to dynamically adjust system parameters to enhance performance during intensive terminal operations, with the ability to restore default settings when no longer needed.

The project includes two primary functions:
- `IncreaseWarpFactor`: Optimizes system resources for maximum Warp Terminal performance
- `DecreaseWarpFactor`: Restores default system settings for normal operation

## 📋 Requirements

- macOS (tested on Monterey, Ventura, and Sonoma)
- Bash or Zsh shell
- Warp Terminal installed
- Administrative privileges (sudo access)

## 🔧 Installation

### Option 1: Script Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/TechAndBackLTD/warpfactor.git
   cd warpfactor
   ```

2. Make the script executable:
   ```bash
   chmod +x warpfactor.sh
   ```

3. Use directly or add to your path:
   ```bash
   sudo cp warpfactor.sh /usr/local/bin/warpfactor
   ```

### Option 2: Shell Integration

Add the functions to your `.zshrc` or `.bashrc`:

1. Open your shell configuration file:
   ```bash
   nano ~/.zshrc  # or ~/.bashrc
   ```

2. Add the following line:
   ```bash
   source /path/to/warpfactor.sh
   ```

3. Reload your shell configuration:
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

## 🚀 Usage

### Command Line Usage

When installed as a standalone script:

```bash
# Optimize system for Warp performance
warpfactor increase

# Restore default system settings
warpfactor decrease
```

### Function Usage

When sourced in your shell:

```bash
# Optimize system for Warp performance
IncreaseWarpFactor

# Restore default system settings
DecreaseWarpFactor
```

## ⚙️ Configuration Options

The script modifies the following system parameters:

| Parameter | Default Value | Optimized Value | Description |
|-----------|---------------|----------------|-------------|
| kern.maxproc | 4000 | 2500 | Maximum number of processes system-wide |
| kern.maxprocperuid | 2666 | 2000 | Maximum processes per user |
| kern.sysv.shmmax | 4194304 | 16777216 | Maximum size of shared memory segment |
| kern.sysv.shmall | 1024 | 65536 | Maximum amount of shared memory |
| maxfiles | system default | 4096/unlimited | File descriptor limits |

To customize these values, edit the script's `TARGET_*` variables:

```bash
# In warpfactor.sh
TARGET_MAXPROC=2500        # Adjust this value
TARGET_MAXPROCPERUID=2000  # Adjust this value
TARGET_SHMMAX=16777216     # Adjust this value
TARGET_SHMALL=65536        # Adjust this value
```

## 📖 Documentation

For detailed information about the configuration, system impacts, and monitoring capabilities, see the [WarpFactor_Configuration_Review.md](WarpFactor_Configuration_Review.md) document.

## 🔍 Process Management

WarpFactor automatically:

1. Identifies running Warp Terminal processes
2. Adjusts process priorities (nice values)
3. Manages system sleep prevention
4. Cleans up resources when restoring defaults

## 📝 License

This project is licensed under the MIT License with the Churchman Rider I clause - see the [LICENSE.md](LICENSE.md) file for details. Copyright © 2025 To Tech and Back, LTD., with Jared Churchman as Chief Engineer and sole owner.

## 👏 Attribution

For complete attribution information, including acknowledgment of Warp Terminal developers and AI assistance, see the [ATTRIBUTION.md](ATTRIBUTION.md) file.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## ⚠️ Disclaimer

Use this utility at your own risk. While designed to be safe and reversible, modifying system parameters can potentially affect system stability. Always ensure you understand the changes being made to your system.

