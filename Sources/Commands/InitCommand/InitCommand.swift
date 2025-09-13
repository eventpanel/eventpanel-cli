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
        let outputFilePath = try requestGeneratedEventsPath(for: source)

        switch source {
        case .iOS:
            return .swiftgen(.make(outputFilePath: outputFilePath))
        case .android:
            return .kotlingen(.make(outputFilePath: outputFilePath))
        }
    }
    
    private func requestGeneratedEventsPath(for source: Source) throws -> String {
        let folderURL = try requestGeneratedEventsFolder()
        let fileName = try requestFileName(for: source)
        
        // Combine folder path with filename
        let fullPath = folderURL.appendingPathComponent(fileName).path
        let relativePath = String(fullPath.dropFirst(configFileLocation.workingDirectory.path.count + 1))
        
        return relativePath
    }

    private func requestGeneratedEventsFolder() throws -> URL {
        ConsoleLogger.message(
            "Enter the folder path for generated events (relative to current directory, default: ./): ",
            terminator: ""
        )
        let input = _readLine()?.trimmingCharacters(in: .whitespacesAndNewlines)

        return try outputPathResolver.resolvePath(
            input: input,
            defaultFileName: "./",
            workingDirectory: configFileLocation.workingDirectory
        )
    }

    private func requestFileName(for source: Source) throws -> String {
        let (prompt, defaultFileName) = getFileNamePrompt(for: source)
        
        ConsoleLogger.message(prompt, terminator: "")
        let input = _readLine()?.trimmingCharacters(in: .whitespacesAndNewlines)

        let fileName = input?.isEmpty == false ? input! : defaultFileName
        
        return try validateFileName(fileName, for: source)
    }
    
    private func getFileNamePrompt(for source: Source) -> (prompt: String, defaultFileName: String) {
        switch source {
        case .iOS:
            return (
                prompt: "Enter the filename for generated events (default: \(SwiftGenPlugin.defaultOutputFilePath)): ",
                defaultFileName: SwiftGenPlugin.defaultOutputFilePath
            )
        case .android:
            return (
                prompt: "Enter the filename for generated events (default: \(KotlinGenPlugin.defaultOutputFilePath)): ",
                defaultFileName: KotlinGenPlugin.defaultOutputFilePath
            )
        }
    }
    
    private func validateFileName(_ fileName: String, for source: Source) throws -> String {
        switch source {
        case .iOS:
            return try SwiftFileNameValidator.validate(fileName)
        case .android:
            return try KotlinFileNameValidator.validate(fileName)
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
