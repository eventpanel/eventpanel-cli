# Contributing to EventPanel

Thank you for your interest in contributing to EventPanel! This document provides guidelines and information for contributors.

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the maintainers.

## Getting Started

### Prerequisites

- Swift 5.9+ (for development)
- Xcode 15+ (for iOS development)
- Android Studio (for Android development)
- Homebrew (for package management)

### Setting Up Development Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/eventpanel/eventpanel-cli.git
   cd eventpanel-cli
   ```

2. Install dependencies:
   ```bash
   swift package resolve
   ```

3. Build the project:
   ```bash
   swift build
   ```

4. Run tests:
   ```bash
   swift test
   ```

## Development Workflow

### Branch Naming

- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring

### Pull Request Process

1. Create a feature branch from `main`
2. Make your changes
3. Add tests for new functionality
4. Ensure all tests pass
5. Update documentation if needed
6. Submit a pull request with a clear description

## Testing

### Running Tests

```bash
# Run all tests
swift test

# Run specific test
swift test --filter TestClassName

# Run with verbose output
swift test --verbose
```

### Test Guidelines

- Write unit tests for new functionality
- Update snapshot tests when changing generated code
- Ensure tests are deterministic and don't depend on external services
- Mock external dependencies in tests

## Code Style

### Swift

- Follow Swift API Design Guidelines
- Use `swiftformat` for consistent formatting
- Prefer explicit types over type inference when it improves readability
- Use meaningful variable and function names

### Documentation

- Document public APIs with Swift doc comments
- Include usage examples in documentation
- Keep README.md updated with new features

## Architecture

### Project Structure

```
Sources/
├── Application.swift          # Main CLI application
├── Commands/                  # Command implementations
├── CommandDefinitions/        # Command definitions
├── Models/                    # Data models
├── Plugins/                   # Code generation plugins
├── Services/                  # Business logic services
└── Utils/                     # Utility functions
```

### Key Components

- **Commands**: CLI command implementations
- **Plugins**: Code generation for Swift/Kotlin
- **Services**: API communication and token management
- **Models**: Data structures and YAML handling

## Reporting Issues

When reporting issues, please include:

1. EventPanel version
2. Operating system and version
3. Steps to reproduce
4. Expected vs actual behavior
5. Relevant logs or error messages

## Feature Requests

For feature requests, please:

1. Check existing issues first
2. Provide a clear description of the feature
3. Explain the use case and benefits
4. Consider implementation complexity

## Release Process

Releases are managed by maintainers. The process includes:

1. Version bumping
2. Changelog updates
3. Tag creation
4. GitHub release
5. Homebrew formula update

## Questions?

Feel free to open an issue for questions or reach out to the maintainers.
