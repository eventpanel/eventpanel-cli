import Foundation
import ArgumentParser

@main
struct EventPanel: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
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
        ]
    )

    @Option(name: .long, help: "Path to EventPanel.yaml configuration file")
    var config: String?

    func validate() throws {
        // Add your pre-execution checks here
        // For example, checking if config file exists when specified
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
        // This is the default command that runs when no subcommand is specified
        print(EventPanel.helpMessage())
    }
}
