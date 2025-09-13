import Foundation

final class InitCommand {
    private let projectDetector: ProjectDetector
    private let configProvider: ConfigProvider
    private let configFileLocation: ConfigFileLocation
    private let outputPathResolver: OutputPathResolver
    private let _readLine: () -> String?

    init(
        projectDetector: ProjectDetector,
        configProvider: ConfigProvider,
        configFileLocation: ConfigFileLocation,
        outputPathResolver: OutputPathResolver,
        readLine: @Sendable @escaping () -> String? = { readLine() }
    ) {
        self.projectDetector = projectDetector
        self.configProvider = configProvider
        self.configFileLocation = configFileLocation
        self.outputPathResolver = outputPathResolver
        self._readLine = readLine
    }
    
    func execute() async throws {
        let eventPanelYaml = try? await configProvider.getEventPanelYaml()
        if eventPanelYaml != nil { throw InitCommandError.fileAlreadyExists }

        let projectDirectory = try detectProject(in: configFileLocation.workingDirectory)
        let plugin = try initializePlugin(for: projectDirectory.source)

        let projectInfo = ProjectInfo.init(
            name: projectDirectory.name,
            source: projectDirectory.source,
            plugin: plugin
        )

        try await configProvider.create(
            at: configFileLocation.configFilePath,
            projectInfo: projectInfo
        )

        ConsoleLogger.success("Created EventPanel.yaml")
    }

    private func initializePlugin(for source: Source) throws -> Plugin {
        let generatedEventsPath = try requestGeneratedEventsPath()

        switch source {
        case .iOS:
            return .swiftgen(.make(generatedEventsPath: generatedEventsPath.relativePath))
        case .android:
            return .kotlingen(.default)
        }
    }

    private func requestGeneratedEventsPath() throws -> URL {
        ConsoleLogger.message(
            "Enter a relative file path (default: GeneratedAnalyticsEvents.swift): ",
            terminator: ""
        )
        let input = _readLine()?.trimmingCharacters(in: .whitespacesAndNewlines)

        return try outputPathResolver.resolvePath(
            input: input,
            defaultFileName: "GeneratedAnalyticsEvents.swift",
            workingDirectory: configFileLocation.workingDirectory
        )
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
    case invalidPath(URL)
    case notNestedPath(URL)

    var errorDescription: String? {
        switch self {
        case .fileAlreadyExists:
            return "Existing EventPanel.yaml found in directory"
        case .noSupportedProject:
            return "No supported project found in the current directory"
        case .invalidPath(let dirURL):
            return "Cannot create directory at \(dirURL.path)"
        case .notNestedPath(let dirURL):
            return "The file must be inside the workspace directory \(dirURL.path)"
        }
    }
}
