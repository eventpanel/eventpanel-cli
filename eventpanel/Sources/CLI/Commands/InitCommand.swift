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
        let eventfilePath = (currentPath as NSString).appendingPathComponent("EventPanel.yaml")
        
        if fileManager.fileExists(atPath: eventfilePath) {
            throw CommandError.fileAlreadyExists("[!] Existing EventPanel.yaml found in directory")
        }
        
        try createEventfile(at: eventfilePath)
        print("Created EventPanel.yaml")
    }
    
    private func createEventfile(at path: String) throws {
        let template = """
        # EventPanel configuration file

        # Global settings
        # platform: ios
        # minimum_version: '15.0'

        # Target configurations
        targets:
          # Main app target
          # MyApp:
          #   events:
          #     - name: "App Launch"
          #     - name: "User Sign In"
          #     - name: "Purchase Complete"
          #       version: "2"

          # Watch app target
          # MyAppWatch:
          #   events:
          #     - name: "Watch App Launch"
          #     - name: "Workout Started"

          # Widget target
          # MyAppWidget:
          #   events:
          #     - name: "Widget Viewed"

        """
        
        try template.write(toFile: path, atomically: true, encoding: .utf8)
    }
}
