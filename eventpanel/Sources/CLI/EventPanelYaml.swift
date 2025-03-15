import Foundation
import Yams

enum EventPanelYamlError: LocalizedError {
    case invalidYamlStructure(String)
    case targetNotFound(String)
    case eventAlreadyExists(eventId: String, target: String)
    case eventNotFound(eventId: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidYamlStructure(let message):
            return "Invalid YAML structure: \(message)"
        case .targetNotFound(let target):
            return "Target '\(target)' not found in configuration"
        case .eventAlreadyExists(let eventId, let target):
            return "Event '\(eventId)' already exists in target '\(target)'"
        case .eventNotFound(let eventId):
            return "Event not found '\(eventId)'"
        }
    }
}

final class EventPanelYaml {
    private var config: EventPanelConfig
    private let path: String

    static func read(fileManager: FileManager = .default) throws -> EventPanelYaml {
        let currentPath = fileManager.currentDirectoryPath
        let eventfilePath = (currentPath as NSString).appendingPathComponent("EventPanel.yaml")

        guard fileManager.fileExists(atPath: eventfilePath) else {
            throw CommandError.projectIsNotInitialized
        }

        let eventPanelYaml = try EventPanelYaml(path: eventfilePath)
        return eventPanelYaml
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
            minimumVersion: projectInfo.defaultVersion,
            targets: [
                projectInfo.name: Target(events: [])
            ]
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

    func getTargets() -> [String] {
        return Array(config.targets.keys)
    }

    func addEvent(eventId: String, to targetName: String) throws {
        guard var target = config.targets[targetName] else {
            throw EventPanelYamlError.targetNotFound(targetName)
        }
        
        if target.events.contains(where: { $0.name == eventId }) {
            throw EventPanelYamlError.eventAlreadyExists(
                eventId: eventId,
                target: targetName
            )
        }
        
        target.events.append(Event(name: eventId))
        config.targets[targetName] = target
        try save()
    }
    
    func getEvents(for targetName: String) throws -> [Event] {
        guard let target = config.targets[targetName] else {
            throw EventPanelYamlError.targetNotFound(targetName)
        }
        return target.events
    }
    
    func updateEvent(eventId: String, version: String) throws {
        var updated = false
        
        for (targetName, var target) in config.targets {
            if let eventIndex = target.events.firstIndex(where: { $0.name == eventId }) {
                target.events[eventIndex].version = version
                config.targets[targetName] = target
                updated = true
            }
        }
        
        if !updated {
            throw EventPanelYamlError.eventNotFound(eventId: eventId)
        }
        
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
    let platform: String
    let defaultVersion: String
} 
