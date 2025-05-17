import Foundation

final class DeintegrateCommand {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func execute() async throws {
        let currentPath = fileManager.currentDirectoryPath
        let configPath = (currentPath as NSString).appendingPathComponent("EventPanel.yaml")
        
        if fileManager.fileExists(atPath: configPath) {
            try fileManager.removeItem(atPath: configPath)
            ConsoleLogger.success("Successfully removed EventPanel.yaml")
        } else {
            ConsoleLogger.error("No EventPanel.yaml found in current directory")
        }
    }
} 
