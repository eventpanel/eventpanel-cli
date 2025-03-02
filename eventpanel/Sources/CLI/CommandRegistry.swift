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
    
    func getFormattedCommandList() -> String {
        let maxNameLength = availableCommands.map { $0.name.count }.max() ?? 0
        let padding = maxNameLength + 4
        
        return availableCommands
            .sorted { $0.name < $1.name }
            .map { command in
                let paddedName = command.name.padding(toLength: padding, withPad: " ", startingAt: 0)
                return "    + \(paddedName)\(command.description)"
            }
            .joined(separator: "\n")
    }
} 
