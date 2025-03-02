import Foundation

final class CommandLineInterface {
    private let commandProcessor: CommandProcessor
    private let commandRegistry: CommandRegistry
    
    init(commandProcessor: CommandProcessor = CommandProcessor(), 
         commandRegistry: CommandRegistry = CommandRegistry()) {
        self.commandProcessor = commandProcessor
        self.commandRegistry = commandRegistry
    }
    
    func start() async {
        let arguments = Array(CommandLine.arguments.dropFirst())
        guard !arguments.isEmpty else {
            printUsage()
            return
        }
        
        await commandProcessor.process(arguments)
    }
    
    private func printUsage() {
        ConsoleLogger.message("""
        Usage:
            $ eventpanel COMMAND

            EventPanel, the event management system.

        Commands:
        \(commandRegistry.getFormattedCommandList())

        Options:
            --verbose      Show more debugging information
            --help        Show help banner of specified command
        """)
    }
} 
