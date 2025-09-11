# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial open source release
- Support for iOS (Swift) and Android (Kotlin) code generation
- YAML-based event configuration
- Secure token management with keychain storage
- Command-line interface with multiple subcommands
- Snapshot testing for generated code

### Changed
- Made API endpoints configurable via environment variables
- Improved error handling and user experience
- Enhanced documentation and examples

## [1.0.0] - 2025-09-XX

### Added
- Initial release of EventPanel CLI
- Support for Swift code generation with SwiftGen plugin
- Support for Kotlin code generation with KotlinGen plugin
- Event management commands (add, list, update, outdated)
- Authentication system with API token management
- Project initialization and deintegration
- Code generation from EventPanel.yaml configuration
- Integration with EventPanel backend API

### Commands
- `init` - Initialize EventPanel in a project
- `add` - Add new events to configuration
- `list` - List configured events
- `update` - Update events to latest versions
- `outdated` - Show outdated events
- `generate` - Generate code from configuration
- `pull` - Fetch latest scheme from server
- `deintegrate` - Remove EventPanel from project
- `auth set-token` - Set API authentication token
- `auth remove-token` - Remove stored API token

### Features
- Multi-platform support (iOS/Android)
- Secure token storage using macOS keychain
- YAML configuration file management
- Template-based code generation
- Snapshot testing for regression prevention
- Comprehensive error handling
- Verbose logging support
