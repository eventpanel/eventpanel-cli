import Foundation

final class GenerateCommand: Command {
    let name = "generate"
    let description = "Generate events according to versions from a EventPanel.yaml"
    
    func execute(with arguments: [String]) throws {
        print("Generating events from EventPanel.yaml...")
        // TODO: Implementation
    }
} 