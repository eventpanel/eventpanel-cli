import Foundation

private enum InitCommandError: LocalizedError {
    case fileAlreadyExists
    case noSupportedProject
    
    var errorDescription: String? {
        switch self {
        case .fileAlreadyExists:
            return "Existing EventPanel.yaml found in directory"
        case .noSupportedProject:
            return "No supported project found in the current directory"
        }
    }
}

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
            throw InitCommandError.fileAlreadyExists
        }
        
        let projectInfo = try detectProject(in: currentPath)
        try EventPanelYaml.createDefault(at: eventfilePath, projectInfo: projectInfo)
        ConsoleLogger.success("Created EventPanel.yaml")
    }
    
    private func detectProject(in directory: String) throws -> ProjectInfo {
        // Check for Xcode project first
        if let projectName = findXcodeProject(in: directory) {
            return ProjectInfo(
                name: projectName,
                platform: "ios",
                defaultVersion: "15.0"
            )
        }
        
        // For now, if no project is found, throw an error
        throw InitCommandError.noSupportedProject
    }
    
    private func findXcodeProject(in directory: String) -> String? {
        guard let contents = try? fileManager.contentsOfDirectory(atPath: directory) else {
            return nil
        }
        
        let xcodeProjects = contents.filter { $0.hasSuffix(".xcodeproj") }
        guard let projectPath = xcodeProjects.first else {
            return nil
        }
        
        return (projectPath as NSString).deletingPathExtension
    }
}
