import Foundation

final class CommandProcessor {
    private let commandRegistry: CommandRegistry
    
    init(commandRegistry: CommandRegistry) {
        self.commandRegistry = commandRegistry
    }
    
    func process(_ arguments: [String]) async {
        guard let commandName = arguments.first else { return }
        let commandArguments = Array(arguments.dropFirst())
        
        if let command = commandRegistry.findCommand(named: commandName) {
            do {
                try await command.execute(with: commandArguments)
            } catch {
                ConsoleLogger.error(error.localizedDescription)
                exit(1)
            }
        } else {
            ConsoleLogger.error("Unknown command '\(commandName)'. Run 'eventpanel help' for available commands.")
            exit(1)
        }
    }
} 
