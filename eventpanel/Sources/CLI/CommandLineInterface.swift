import Foundation

final class CommandLineInterface {
    private let commandProcessor: CommandProcessor
    
    init(commandProcessor: CommandProcessor = CommandProcessor()) {
        self.commandProcessor = commandProcessor
    }
    
    func start() {
        let arguments = Array(CommandLine.arguments.dropFirst())
        guard !arguments.isEmpty else {
            printUsage()
            return
        }
        
        commandProcessor.process(arguments)
    }
    
    private func printUsage() {
        print("""
        Usage: eventpanel <command> [options]
        
        For available commands, run:
        eventpanel help
        """)
    }
} 