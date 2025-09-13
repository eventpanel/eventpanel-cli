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

    @Option(name: .long, help: "Path to working directory")
    var workdir: String?

    @Flag(name: .long, help: "Enable verbose output")
    var verbose = false

    func validate() throws {
        ConsoleLogger.isVerbose = verbose
        
        try ConfigFileLocationProvider.initialize(
            configPath: config,
            workDir: workdir
        )
    }

    func run() throws {
        ConsoleLogger.message(EventPanel.helpMessage())
    }
}
