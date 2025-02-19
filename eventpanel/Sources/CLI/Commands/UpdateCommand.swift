import Foundation

final class UpdateCommand: Command {
    let name = "update"
    let description = "Update outdated project dependencies and create new EventPanel.lock"
    
    func execute(with arguments: [String]) throws {
        print("Updating events...")
        // TODO: Implementation
    }
} 