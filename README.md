# HealBarsClassic-Cell

<div align="center">

[![GitHub release](https://img.shields.io/github/v/release/sbv29/healbarsclassic-cell?style=flat-square)](https://github.com/sbv29/healbarsclassic-cell/releases)
[![Downloads](https://img.shields.io/github/downloads/sbv29/healbarsclassic-cell/total?style=flat-square)](https://github.com/sbv29/healbarsclassic-cell/releases)
[![Issues](https://img.shields.io/github/issues/sbv29/healbarsclassic-cell?style=flat-square)](https://github.com/sbv29/healbarsclassic-cell/issues)

**A powerful healing addon for World of Warcraft Classic**

[Features](#features) • [Installation](#installation) • [Usage](#usage) • [Configuration](#configuration) • [Support](#support)

</div>

---

## Overview

HealBarsClassic-Cell is a comprehensive healing addon designed specifically for World of Warcraft Classic. It provides an intuitive cell-based interface for healers to efficiently manage party and raid frames with customizable layouts and real-time health tracking.

## Features

### Core Features
- **Cell-Based Healing Interface** - Clean, organized grid layout for party and raid frames
- **Smart Healing Predictions** - Integration with LibHealComm-4.0 for incoming heal tracking
- **Customizable Layouts** - Flexible frame positioning and sizing options
- **Class-Colored Frames** - Easy visual identification of player classes
- **Range Checking** - Automatic fade-out for out-of-range players
- **Debuff Tracking** - Prominent display of debuffs that you can dispel

### Advanced Features
- **Profile System** - Save and switch between different configurations
- **Auto-Detection** - Automatically adjusts layout based on group size
- **Slash Commands** - Quick access to settings via `/hbc` or `/healbarsclassic`
- **Lightweight** - Optimized for minimal CPU and memory usage
- **Ace3 Framework** - Built on the reliable Ace3 addon framework

## Installation

### Method 1: Direct Download
1. Download the latest release from the [Releases](https://github.com/sbv29/healbarsclassic-cell/releases) page
2. Extract the `HealBarsClassic-Cell` folder to your WoW addons directory:
   - Windows: `C:\Program Files (x86)\World of Warcraft\_classic_\Interface\AddOns\`
   - Mac: `/Applications/World of Warcraft/_classic_/Interface/AddOns/`
3. Restart World of Warcraft or reload your UI with `/reload`

### Method 2: Git Clone
```bash
cd "path/to/WoW/Interface/AddOns"
git clone https://github.com/sbv29/healbarsclassic-cell.git HealBarsClassic-Cell
```

## Usage

### Getting Started
1. Type `/hbc` or `/healbarsclassic` to open the configuration panel
2. Choose your preferred layout (Party, Raid10, Raid25, or Raid40)
3. Adjust frame size, spacing, and positioning to your liking
4. Configure class colors and health display options

### Slash Commands
- `/hbc` or `/healbarsclassic` - Open configuration panel
- `/hbc lock` - Lock/unlock frame positions
- `/hbc reset` - Reset to default settings
- `/hbc profile <name>` - Switch to a different profile

### Key Bindings
You can set up click-casting and key bindings through the WoW Key Bindings menu under "HealBarsClassic-Cell".

## Configuration

### Frame Settings
- **Frame Size**: Adjust width and height of individual cells
- **Spacing**: Control the gap between cells
- **Growth Direction**: Choose how frames expand (down/up, right/left)
- **Groups Per Row/Column**: Organize raid layout

### Display Options
- **Health Text**: Show actual values, percentages, or deficit
- **Power Bars**: Display mana/rage/energy bars
- **Incoming Heals**: Visual indication of heals being cast
- **Range Fade**: Transparency for out-of-range players

### Colors
- **Class Colors**: Use standard class colors or customize
- **Health Colors**: Gradient or threshold-based health coloring
- **Debuff Highlighting**: Border colors for different debuff types

## Compatibility

- **Game Version**: World of Warcraft Classic (1.15.x)
- **Supported Phases**: All Classic phases including Season of Discovery
- **Language Support**: English (enUS), with framework for localization

## Libraries Used

- **Ace3** - Addon development framework
- **LibHealComm-4.0** - Healing prediction library
- **LibStub** - Library versioning system
- **CallbackHandler** - Event management

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Development Setup
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Support

### Bug Reports
Please report bugs through the [Issues](https://github.com/sbv29/healbarsclassic-cell/issues) page. Include:
- Description of the issue
- Steps to reproduce
- Any error messages
- Your WoW Classic version

### Feature Requests
Feature requests are welcome! Please describe:
- The feature you'd like to see
- Why it would be useful
- Any implementation suggestions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the Ace3 development team for their excellent framework
- The WoW Classic healing community for feedback and suggestions
- Cell addon for inspiration on modern healing interfaces

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.

---

<div align="center">

**[Download Latest Version](https://github.com/sbv29/healbarsclassic-cell/releases/latest)** • **[Report Issues](https://github.com/sbv29/healbarsclassic-cell/issues)**

Made with ❤️ for the WoW Classic healing community

</div>