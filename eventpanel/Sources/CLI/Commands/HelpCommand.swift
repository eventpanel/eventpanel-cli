import Foundation

final class HelpCommand: Command {
    private let commandRegistry: CommandRegistry
    
    let name = "help"
    let description = "Show this help message"
    
    init(commandRegistry: CommandRegistry) {
        self.commandRegistry = commandRegistry
    }
    
    func execute(with arguments: [String]) throws {
        ConsoleLogger.message("\nAvailable commands:")
        for command in commandRegistry.availableCommands {
            ConsoleLogger.message("- \(command.name): \(command.description)")
        }
    }
} 
