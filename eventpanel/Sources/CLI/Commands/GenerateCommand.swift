import Foundation

final class GenerateCommand: Command {
    let name = "generate"
    let description = "Generate events according to versions from a EventPanel.lock"
    
    func execute(with arguments: [String]) throws {
        print("Generating events from EventPanel.lock...")
        // TODO: Implementation
    }
} 