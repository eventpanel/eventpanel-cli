import Foundation

final class InitCommand: Command {
    let name = "init"
    let description = "Initializes EventPanel in the project by creating the necessary configuration files"
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func execute(with arguments: [String]) throws {
        let currentPath = fileManager.currentDirectoryPath
        let eventfilePath = (currentPath as NSString).appendingPathComponent("Eventfile")
        
        if fileManager.fileExists(atPath: eventfilePath) {
            throw CommandError.fileAlreadyExists("[!] Existing Eventfile found in directory")
        }
        
        try createEventfile(at: eventfilePath)
        print("✨ Created Eventfile at path: \(eventfilePath)")
    }
    
    private func createEventfile(at path: String) throws {
        let template = """
        # Uncomment the next line to define a global platform for your project
        # platform :ios, '15.0'
        
        target 'YourApp' do
          # Define events for your target here
          # 'App Launch'
          # 'User Sign In'
          # 'Purchase Complete', '2'
        end
        
        """
        
        try template.write(toFile: path, atomically: true, encoding: .utf8)
    }
}