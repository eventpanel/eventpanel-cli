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

final class GenerateCommand: Command {
    let name = "generate"
    let description = "Generate events according to versions from a EventPanel.yaml"
    
    func execute(with arguments: [String]) async throws {
        ConsoleLogger.message("Generating events from EventPanel.yaml...")

        let eventPanelYaml = try EventPanelYaml.read()
        let platform = eventPanelYaml.getPlatform()

        switch platform {
        case .iOS:
            try await generateEventsForIOS()
        }
    }

    private func generateEventsForIOS() async throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swiftgen"]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()

            if process.terminationStatus == 0 {
                ConsoleLogger.success("SwiftGen completed successfully")
            } else {
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    throw GenerateCommandError.swiftgenFailed(output)
                }
                throw GenerateCommandError.swiftgenFailed("Unknown error")
            }
        } catch let error as NSError where error.domain == NSPOSIXErrorDomain && error.code == Int(ENOENT) {
            throw GenerateCommandError.swiftgenNotFound
        } catch {
            throw GenerateCommandError.swiftgenFailed(error.localizedDescription)
        }
    }
}
