import Foundation

final class OutdatedCommand: Command {
    let name = "outdated"
    let description = "Show outdated events"
    
    func execute(with arguments: [String]) throws {
        print("Checking for outdated events...")
        // TODO: Implementation
    }
} 