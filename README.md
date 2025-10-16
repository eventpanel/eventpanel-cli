# EventPanel CLI

EventPanel is a powerful command-line tool for managing analytics events across iOS and Android projects. It generates type-safe event code from YAML configuration files and integrates with the EventPanel platform.

## Features

- 🚀 **Multi-Platform Support**: Generate code for both iOS (Swift) and Android (Kotlin)
- 📝 **YAML Configuration**: Simple, human-readable event definitions
- 🔐 **Secure Authentication**: Keychain-based token storage
- 🎯 **Type Safety**: Generated code ensures compile-time safety
- 🔄 **Version Management**: Track and update event versions
- 📦 **Easy Integration**: Simple project setup and deintegration

## Installation

### Homebrew (Recommended)

```bash
# Add the tap
brew tap eventpanel/eventpanel

# Install EventPanel
brew install eventpanel
```

### Manual Installation

1. Download the latest release from [GitHub Releases](https://github.com/eventpanel/eventpanel-cli/releases)
2. Extract the binary to your PATH
3. Make it executable: `chmod +x eventpanel`

### Building from Source

```bash
git clone https://github.com/eventpanel/eventpanel-cli.git
cd eventpanel-cli
swift build -c release
cp .build/release/eventpanel /usr/local/bin/
```

## Quick Start

1. **Initialize EventPanel in your project:**
   ```bash
   eventpanel init --output MyApp/Analytics/GeneratedEvents.swift
   ```

2. **Set up authentication (optional):**
   ```bash
   eventpanel set-token YOUR_API_TOKEN
   ```

3. **Add your first event:**
   ```bash
   eventpanel add "Profile Screen Closed"
   ```

4. **Generate code:**
   ```bash
   eventpanel generate
   ```

## Usage

### Basic Commands

```bash
# Initialize EventPanel in your project
eventpanel init

# Add a new event
eventpanel add "Profile Screen Closed"

# List all events
eventpanel list

# Generate code from configuration
eventpanel generate

# Update events to latest versions
eventpanel update

# Show outdated events
eventpanel outdated

# Remove EventPanel from project
eventpanel deintegrate
```

### Authentication Commands

```bash
# Set API token for EventPanel platform
eventpanel set-token YOUR_TOKEN

# Remove stored API token
eventpanel remove-token
```

### Options

- `--config <path>`: Specify custom EventPanel.yaml path
- `--verbose`: Enable verbose output
- `--help`: Show help information

## Configuration

EventPanel uses a `EventPanel.yaml` configuration file in your project root:

```yaml
# EventPanel configuration file
source: ios
plugin:
  swiftgen:
    accessModifier: public
    outputPath: "Generated/Events.swift"
    shouldGenerateType: true
    namespace: AnalyticsEvents
    documentation: true
events:
  - id: user_login
  - id: purchase_completed
    version: 2
```

### Configuration Options

- **source**: Platform type (`ios` or `android`)
- **plugin**: Code generation settings
- **events**: List of events with versions

## Supported Platforms

### iOS (Swift)
- Generates Swift enums and structs
- Supports custom types and properties
- Integrates with Xcode projects

### Android (Kotlin)
- Generates Kotlin objects and enums
- Supports custom types and properties
- Integrates with Gradle projects

## Examples

### Example Projects

- **iOS Demo**: [eventpanel-ios-demo](https://github.com/eventpanel/eventpanel-ios-demo) - Complete iOS app demonstrating EventPanel integration
- **Android Demo**: [eventpanel-android-demo](https://github.com/eventpanel/eventpanel-android-demo) - Complete Android app demonstrating EventPanel integration

### Code Examples

#### iOS Example

```swift
// swiftlint:disable all
// Generated using EventPanel — https://github.com/eventpanel/eventpanel-cli

import Foundation

internal enum AnalyticsEvents {
  /// A screen with user data
  internal enum ProfileScreen {

    internal static func profileScreenShown() -> AnalyticsEvent {
      AnalyticsEvent(
        name: "Profile Screen Shown",
        parameters: [:]
      )
    }

    /// Screen is fully closed
    internal static func profileScreenClosed() -> AnalyticsEvent {
      AnalyticsEvent(
        name: "Profile Screen Closed",
        parameters: [:]
      )
    }
  }

  internal static func onboardingScreenShown(  
    origin: Origin?
  ) -> AnalyticsEvent {
    AnalyticsEvent(
      name: "Onboarding Screen Shown",
      parameters: [
        "origin": origin
      ].byExcludingNilValues()
    )
  }
  /// The user sees the full screen loading indicator
  /// - Parameters:
  ///     - city_id: The id of the city
  internal static func loadingScreenShown(  
    cityId: String?
  ) -> AnalyticsEvent {
    AnalyticsEvent(
      name: "Loading Screen Shown",
      parameters: [
        "city_id": cityId
      ].byExcludingNilValues()
    )
  }
}

extension AnalyticsEvents {
    internal enum Origin: String {
      case facebook = "Facebook"
      case insta = "Insta"
    }
}

private extension Dictionary where Value == Any? {
    /// Returns dictionary with filtered out `nil` and `NSNull` values
    func byExcludingNilValues() -> [Key: Any] {
        return compactMapValues { value -> Any? in
            value is NSNull ? nil : value
        }
    }
} 
// swiftlint:enable all
```

#### Android Example

```kotlin
// Generated using EventPanel — https://github.com/eventpanel/eventpanel-cli

package com.example.pizzadelivery

internal object GeneratedAnalyticsEvents {
  /**
   * A screen with user data
   */
  internal object ProfileScreen {

    internal fun profileScreenShown(): AnalyticsEvent {
      return AnalyticsEvent(
        name = "Profile Screen Shown",
        parameters = emptyMap()
      )
    }

    /**
     * Screen is fully closed
     */
    internal fun profileScreenClosed(): AnalyticsEvent {
      return AnalyticsEvent(
        name = "Profile Screen Closed",
        parameters = emptyMap()
      )
    }
  }

  internal fun onboardingScreenShown(  
    origin: Origin?
  ): AnalyticsEvent {
    return AnalyticsEvent(
      name = "Onboarding Screen Shown",
      parameters = mapOf(
        "origin" to origin
      ).withoutNulls()
    )
  }
  
  /**
   * The user sees the full screen loading indicator
   * @param city_id The id of the city
   */
  internal fun loadingScreenShown(  
    cityId: String?
  ): AnalyticsEvent {
    return AnalyticsEvent(
      name = "Loading Screen Shown",
      parameters = mapOf(
        "city_id" to cityId
      ).withoutNulls()
    )
  }
}

// Custom types for analytics
internal enum class Origin(val value: String) {
  Facebook("Facebook"),
  Insta("Insta")
}

private fun Map<String, Any?>.withoutNulls(): Map<String, Any> =
    this.filterValues { it != null }.mapValues { it.value!! }
```

## Development

### Prerequisites
- Swift 5.9+
- Xcode 15+ (for iOS development)
- Android Studio (for Android development)

### Building
```bash
swift build
```

### Testing
```bash
swift test
```

### Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [Documentation](https://eventpanel.net/docs)
- 🐛 [Report Issues](https://github.com/eventpanel/eventpanel-cli/issues)
- 💬 [Discussions](https://github.com/eventpanel/eventpanel-cli/discussions)
- 🌐 [Website](https://eventpanel.net)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
