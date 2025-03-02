import Foundation

final class UpdateCommand: Command {
    let name = "update"
    let description = "Update outdated events"
    
    func execute(with arguments: [String]) throws {
        ConsoleLogger.message("Updating events...")
        // TODO: Implementation
    }
} 
