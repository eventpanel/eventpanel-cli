import Foundation

final class InitCommand: Command {
    let name = "init"
    let description = "Initializes EventPanel in the project by creating the necessary configuration files"
    
    func execute(with arguments: [String]) throws {
        print("Initializing EventPanel...")
        // TODO: Create EventPanel configuration files
    }
} 