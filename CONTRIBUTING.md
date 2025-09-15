# Contributing to HealBarsClassic-Cell

First off, thank you for considering contributing to HealBarsClassic-Cell! It's people like you that make this addon better for the entire WoW Classic healing community.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, please include as many details as possible using our bug report template.

**Great Bug Reports** tend to have:
- A quick summary and/or background
- Steps to reproduce (be specific!)
- What you expected would happen
- What actually happens
- Screenshots (if applicable)
- Notes (possibly including why you think this might be happening)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:
- A clear and descriptive title
- A detailed description of the proposed enhancement
- Explain why this enhancement would be useful to most healers
- List any other addons where you've seen this feature

### Pull Requests

1. Fork the repo and create your branch from `master`
2. Make your changes
3. Ensure your code follows the existing style
4. Test your changes thoroughly in-game
5. Create a pull request with a clear description

## Development Setup

### Prerequisites
- World of Warcraft Classic client
- A text editor (VS Code recommended)
- Git

### Setting Up Your Environment

1. Fork and clone the repository
```bash
git clone https://github.com/your-username/healbarsclassic-cell.git
```

2. Create a symlink to your WoW AddOns folder
```bash
# Windows (run as Administrator)
mklink /D "C:\Program Files (x86)\World of Warcraft\_classic_\Interface\AddOns\HealBarsClassic-Cell-Dev" "C:\path\to\your\clone"

# Mac/Linux
ln -s /path/to/your/clone "/Applications/World of Warcraft/_classic_/Interface/AddOns/HealBarsClassic-Cell-Dev"
```

3. Enable Lua errors in-game
```
/console scriptErrors 1
```

### Code Style Guidelines

- Use consistent indentation (4 spaces)
- Comment complex logic
- Follow existing naming conventions
- Keep functions focused and small
- Use descriptive variable names

### Testing Your Changes

Before submitting:
1. Test in solo play
2. Test in a 5-man party
3. Test in raids (10/25/40 if possible)
4. Test with different classes
5. Check for Lua errors
6. Verify performance impact

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Public or private harassment
- Publishing others' private information

## Questions?

Feel free to open an issue with the "question" label if you need help or clarification.

Thank you for contributing to HealBarsClassic-Cell!