import Foundation
import ArgumentParser

@main
public struct EventPanel: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(
        commandName: "eventpanel",
        abstract: "EventPanel, the event management system.",
        subcommands: [
            Add.self,
            Auth.self,
            Deintegrate.self,
            Generate.self,
            Help.self,
            Init.self,
            List.self,
            Outdated.self,
            Pull.self,
            Update.self
        ]
    )

    @Option(name: .long, help: "Path to EventPanel.yaml configuration file")
    public var config: String?
    
    @Flag(name: .long, help: "Enable verbose output")
    public var verbose = false

    public init() {}

    public func validate() throws {
        ConsoleLogger.isVerbose = verbose
        
        if let configPath = config {
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: configPath) {
                throw ValidationError("Configuration file not found at path: \(configPath)")
            } else {
                EventPanelYaml.setConfigPath(configPath)
            }
        }
    }

    public func run() throws {
        ConsoleLogger.message(EventPanel.helpMessage())
    }
}
