import Foundation

final class InitCommand {
    private let generatorPluginFactory: GeneratorPluginFactory
    private let projectDetector: ProjectDetector
    private let configProvider: ConfigProvider
    private let configFileLocation: ConfigFileLocation

    init(
        generatorPluginFactory: GeneratorPluginFactory,
        projectDetector: ProjectDetector,
        configProvider: ConfigProvider,
        configFileLocation: ConfigFileLocation
    ) {
        self.generatorPluginFactory = generatorPluginFactory
        self.projectDetector = projectDetector
        self.configProvider = configProvider
        self.configFileLocation = configFileLocation
    }
    
    func execute() async throws {
        let eventPanelYaml = try? await configProvider.getEventPanelYaml()
        if eventPanelYaml != nil { throw InitCommandError.fileAlreadyExists }

        let projectInfo = try detectProject(in: configFileLocation.workingDirectory)
        try await configProvider.create(at: configFileLocation.configFilePath, projectInfo: projectInfo)

        ConsoleLogger.success("Created EventPanel.yaml")
    }

    private func detectProject(in directory: URL) throws -> ProjectInfo {
        guard let project = projectDetector.detectProject(in: directory) else {
            throw InitCommandError.noSupportedProject
        }
        return project
    }
}

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
