import Foundation

protocol ConfigProvider: Sendable {
    func getEventPanelYaml() async throws -> EventPanelYaml
}

final class FileConfigProvider: @unchecked Sendable, ConfigProvider {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func getEventPanelYaml() async throws -> EventPanelYaml {
        try EventPanelYaml.read(fileManager: fileManager)
    }
}
