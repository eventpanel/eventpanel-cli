import Foundation

enum GenerateCommandError: LocalizedError {
    case swiftgenFailed(String)
    case swiftgenNotFound
    case invalidConfiguration
    
    var errorDescription: String? {
        switch self {
        case .swiftgenFailed(let message):
            return "SwiftGen execution failed: \(message)"
        case .swiftgenNotFound:
            return "SwiftGen not found. Please install SwiftGen and ensure it's in your PATH"
        case .invalidConfiguration:
            return "Invalid SwiftGen configuration. Please check your swiftgen.yml file"
        }
    }
}

final class GenerateCommand {
    private let eventPanelYaml: EventPanelYaml

    init(eventPanelYaml: EventPanelYaml) {
        self.eventPanelYaml = eventPanelYaml
    }

    func execute() async throws {
        ConsoleLogger.message("Generating events from EventPanel.yaml...")

        let plugin = await eventPanelYaml.getPlugin()

        do {
            try await plugin.generator.run()
        } catch let error as NSError where error.domain == NSPOSIXErrorDomain && error.code == Int(ENOENT) {
            throw GenerateCommandError.swiftgenNotFound
        } catch {
            throw GenerateCommandError.swiftgenFailed(error.localizedDescription)
        }
    }
}
