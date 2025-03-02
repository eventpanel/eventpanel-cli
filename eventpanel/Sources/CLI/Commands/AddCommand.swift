import Foundation

final class AddCommand: Command {
    let name = "add"
    let description = "Add event to EventPanel.yaml"
    
    func execute(with arguments: [String]) throws {
        guard !arguments.isEmpty else {
            throw CommandError.invalidArguments("Usage: eventpanel add <event_name> [version]")
        }
        
        print("Adding event to EventPanel.yaml...")
        // TODO: Implementation
    }
} 
