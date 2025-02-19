import Foundation

final class CommandProcessor {
    private let commandRegistry: CommandRegistry
    
    init(commandRegistry: CommandRegistry = CommandRegistry()) {
        self.commandRegistry = commandRegistry
    }
    
    func process(_ arguments: [String]) {
        guard let commandName = arguments.first else { return }
        let commandArguments = Array(arguments.dropFirst())
        
        if let command = commandRegistry.findCommand(named: commandName) {
            do {
                try command.execute(with: commandArguments)
            } catch {
                print("Error: \(error.localizedDescription)")
                exit(1)
            }
        } else {
            print("Unknown command '\(commandName)'. Run 'eventpanel help' for available commands.")
            exit(1)
        }
    }
} 