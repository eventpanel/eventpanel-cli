import Foundation

final class InitCommand {
    private let projectDetector: ProjectDetector
    private let configProvider: ConfigProvider
    private let configFileLocation: ConfigFileLocation
    private let outputPathValidator: OutputPathValidator

    init(
        projectDetector: ProjectDetector,
        configProvider: ConfigProvider,
        configFileLocation: ConfigFileLocation,
        outputPathValidator: OutputPathValidator
    ) {
        self.projectDetector = projectDetector
        self.configProvider = configProvider
        self.configFileLocation = configFileLocation
        self.outputPathValidator = outputPathValidator
    }

    func execute(outputPath: String, source: Source? = nil) async throws {
        let eventPanelYaml = try? await configProvider.getEventPanelYaml()
        if eventPanelYaml != nil { throw InitCommandError.fileAlreadyExists }

        let projectDirectory: ProjectDirectory
        if let providedSource = source {
            projectDirectory = ProjectDirectory(source: providedSource)
        } else {
            projectDirectory = try detectProject(in: configFileLocation.workingDirectory)
        }
        
        let plugin = try initializePlugin(for: projectDirectory.source, outputPath: outputPath)

        let projectInfo = ProjectInfo(
            source: projectDirectory.source,
            plugin: plugin
        )

        try await configProvider.create(
            at: configFileLocation.configFilePath,
            projectInfo: projectInfo
        )

        ConsoleLogger.success("Created EventPanel.yaml")
    }

    private func initializePlugin(for source: Source, outputPath: String) throws -> Plugin {
        let outputFilePath = try outputPathValidator.validate(
            outputPath,
            for: source,
            workingDirectory: configFileLocation.workingDirectory
        )

        switch source {
        case .iOS:
            return .swiftgen(.make(outputFilePath: outputFilePath))
        case .android:
            return .kotlingen(.make(outputFilePath: outputFilePath))
        case .web:
            return .typescriptgen(.make(outputFilePath: outputFilePath))
        }
    }

    private func detectProject(in directory: URL) throws -> ProjectDirectory {
        guard let project = projectDetector.detectProject(in: directory) else {
            throw InitCommandError.noSupportedProject
        }
        return project
    }
}

enum InitCommandError: LocalizedError {
    case fileAlreadyExists
    case noSupportedProject
    case invalidSource(String)

    var errorDescription: String? {
        switch self {
        case .fileAlreadyExists:
            return "Existing EventPanel.yaml found in directory"
        case .noSupportedProject:
            return "Specify the source using the --source parameter. Options: android, iOS, or web"
        case .invalidSource(let source):
            return "Invalid source '\(source)'. Valid options are: android, iOS, web"
        }
    }
}
