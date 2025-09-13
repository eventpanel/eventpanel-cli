import Foundation

protocol ConfigProvider: Sendable {
    func getEventPanelYaml() async throws -> EventPanelYaml
    func create(at filePath: URL, projectInfo: ProjectInfo) async throws
}

final class FileConfigProvider: @unchecked Sendable, ConfigProvider {
    private let fileManager: FileManager
    private let configFileLocation: ConfigFileLocation

    init(
        configFileLocation: ConfigFileLocation,
        fileManager: FileManager
    ) {
        self.configFileLocation = configFileLocation
        self.fileManager = fileManager
    }
    
    func getEventPanelYaml() async throws -> EventPanelYaml {
        let eventPanelYaml = try EventPanelYaml(path: configFileLocation.configFilePath.relativePath)
        return eventPanelYaml
    }

    func create(at filePath: URL, projectInfo: ProjectInfo) async throws {
        try EventPanelYaml.createDefault(
            at: filePath.relativePath,
            projectInfo: projectInfo
        )
    }
}
