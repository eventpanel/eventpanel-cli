# EventPanel CLI

A powerful command-line tool for managing analytics events across iOS and Android projects.

## Installation

### Homebrew (macOS)

```bash
brew tap eventpanel/eventpanel
brew install eventpanel
```

### Manual Installation

**macOS:**
```bash
curl -L https://github.com/eventpanel/eventpanel-cli-releases/releases/latest/download/eventpanel-macos.tar.gz | tar xz
sudo mv eventpanel-macos /usr/local/bin/eventpanel
```

**Linux:**
```bash
curl -L https://github.com/eventpanel/eventpanel-cli-releases/releases/latest/download/eventpanel-linux.tar.gz | tar xz
sudo mv eventpanel-linux /usr/local/bin/eventpanel
```

## Features

- 🚀 Generate type-safe analytics code for iOS (Swift) and Android (Kotlin)
- 📝 Simple YAML configuration
- 🔄 Version management for events
- 🔐 Secure API token storage

## Quick Start

```bash
# Initialize in your project
eventpanel init --output Target/Analytics/GeneratedAnalytics.swift

# Add an event
eventpanel add --name "Button Clicked"

# Generate code
eventpanel generate
```

## Documentation

- 📖 [Full Documentation](https://eventpanel.net/docs)
- 🌐 [Website](https://eventpanel.net)

## Support

- 🐛 [Report Issues](https://github.com/eventpanel/eventpanel-cli-releases/issues)
- 💬 [Discussions](https://github.com/eventpanel/eventpanel-cli-releases/discussions)
