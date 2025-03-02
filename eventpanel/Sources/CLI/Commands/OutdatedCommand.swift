import Foundation

final class OutdatedCommand: Command {
    let name = "outdated"
    let description = "Show outdated events"
    
    func execute(with arguments: [String]) async throws {
        ConsoleLogger.message("Checking for outdated events...")
        // TODO: Implementation
    }
} 
