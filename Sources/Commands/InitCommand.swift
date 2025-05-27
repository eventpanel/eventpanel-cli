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

final class InitCommand {
    private let generatorPluginFactory: GeneratorPluginFactory
    private let fileManager: FileManager
    
    init(
        generatorPluginFactory: GeneratorPluginFactory,
        fileManager: FileManager
    ) {
        self.generatorPluginFactory = generatorPluginFactory
        self.fileManager = fileManager
    }
    
    func execute() async throws {
        let currentPath = fileManager.currentDirectoryPath
        let eventfilePath = (currentPath as NSString).appendingPathComponent("EventPanel.yaml")
        
        if fileManager.fileExists(atPath: eventfilePath) {
            throw InitCommandError.fileAlreadyExists
        }

        let projectInfo = try detectProject(in: currentPath)
        try EventPanelYaml.createDefault(at: eventfilePath, projectInfo: projectInfo)

        try await initilizeGenerator(plugin: projectInfo.plugin)

        ConsoleLogger.success("Created EventPanel.yaml")
    }

    private func initilizeGenerator(plugin: Plugin) async throws {
        let generator = generatorPluginFactory.generator(for: plugin)
        try await generator.initilize()
    }

    private func detectProject(in directory: String) throws -> ProjectInfo {
        // Check for Xcode project first
        if let projectName = findXcodeProject(in: directory) {
            return ProjectInfo(
                name: projectName,
                language: Language.swift,
                plugin: .swiftgen(.default)
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
