import Foundation

final class CommandRegistry {
    private(set) var availableCommands: [Command] = []
    
    init() {
        registerCommands()
    }
    
    private func registerCommands() {
        availableCommands = [
            AddCommand(),
            DeintegrateCommand(),
            GenerateCommand(),
            HelpCommand(commandRegistry: self),
            InitCommand(),
            InstallCommand(),
            ListCommand(),
            OutdatedCommand(),
            UpdateCommand()
        ]
    }
    
    func findCommand(named name: String) -> Command? {
        availableCommands.first { $0.name.lowercased() == name.lowercased() }
    }
} 