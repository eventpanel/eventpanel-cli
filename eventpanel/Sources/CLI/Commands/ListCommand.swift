import Foundation

final class ListCommand: Command {
    let name = "list"
    let description = "List events"
    
    func execute(with arguments: [String]) throws {
        print("Listing events...")
        // TODO: Implementation
    }
} 