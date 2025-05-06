import Foundation
import Yams

enum EventPanelYamlError: LocalizedError {
    case invalidYamlStructure(String)
    case eventAlreadyExists(eventId: String)
    case eventNotFound(eventId: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidYamlStructure(let message):
            return "Invalid YAML structure: \(message)"
        case .eventAlreadyExists(let eventId):
            return "Event '\(eventId)' already exists"
        case .eventNotFound(let eventId):
            return "Event not found '\(eventId)'"
        }
    }
}

final class EventPanelYaml {
    private static var path: String?

    private var config: EventPanelConfig
    private let path: String

    static func read(fileManager: FileManager = .default) throws -> EventPanelYaml {
        let eventfilePath = try Self.getConfigPath(fileManager: fileManager)
        let eventPanelYaml = try EventPanelYaml(path: eventfilePath)
        return eventPanelYaml
    }

    static func setConfigPath(_ path: String) {
        Self.path = path
    }

    private static func getConfigPath(fileManager: FileManager) throws -> String {
        guard let path = Self.path else {
            let currentPath = fileManager.currentDirectoryPath
            let eventfilePath = (currentPath as NSString).appendingPathComponent("EventPanel.yaml")

            guard fileManager.fileExists(atPath: eventfilePath) else {
                throw CommandError.projectIsNotInitialized
            }
            return eventfilePath
        }
        return path
    }

    init(path: String) throws {
        self.path = path
        let yamlString = try String(contentsOfFile: path, encoding: .utf8)
        let decoder = YAMLDecoder()
        self.config = try decoder.decode(EventPanelConfig.self, from: yamlString)
    }
    
    static func createDefault(at path: String, projectInfo: ProjectInfo) throws {
        let config = EventPanelConfig(
            platform: projectInfo.platform,
            plugin: projectInfo.plugin,
            events: []
        )
        
        let encoder = YAMLEncoder()
        let yamlString = try encoder.encode(config)
        
        // Add header comment
        let finalYaml = """
        # EventPanel configuration file
        
        \(yamlString)
        """
        
        try finalYaml.write(toFile: path, atomically: true, encoding: .utf8)
    }

    func getPlatform() -> Platform {
        return config.platform
    }

    func getPlugin() -> Plugin {
        return config.plugin
    }

    func addEvent(eventId: String) throws {
        if config.events.contains(where: { $0.name == eventId }) {
            throw EventPanelYamlError.eventAlreadyExists(eventId: eventId)
        }
        
        config.events.append(Event(name: eventId))
        try save()
    }

    func getEvents() -> [Event] {
        return config.events
    }
    
    func updateEvent(eventId: String, version: Int) throws {
        guard let eventIndex = config.events.firstIndex(where: { $0.name == eventId }) else {
            throw EventPanelYamlError.eventNotFound(eventId: eventId)
        }
        
        config.events[eventIndex].version = version
        try save()
    }
    
    private func save() throws {
        let encoder = YAMLEncoder()
        let yamlString = try encoder.encode(config)
        try yamlString.write(toFile: path, atomically: true, encoding: .utf8)
    }
}

// Move ProjectInfo here since it's related to YAML configuration
struct ProjectInfo {
    let name: String
    let platform: Platform
    let plugin: Plugin
}
