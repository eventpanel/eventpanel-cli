import Foundation
import ArgumentParser

@main
struct EventPanel: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "eventpanel",
        abstract: "EventPanel, the event management system.",
        subcommands: [
            Add.self,
            Deintegrate.self,
            Generate.self,
            Help.self,
            Init.self,
            List.self,
            Outdated.self,
            Pull.self,
            Update.self
        ],
        groupedSubcommands: [CommandGroup(name: "auth", subcommands: [
            SetToken.self,
            RemoveToken.self
        ])]
    )

    @Option(name: .long, help: "Path to EventPanel.yaml configuration file")
    var config: String?
    
    @Flag(name: .long, help: "Enable verbose output")
    var verbose = false

    func validate() throws {
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

    func run() throws {
        ConsoleLogger.message(EventPanel.helpMessage())
    }
}
