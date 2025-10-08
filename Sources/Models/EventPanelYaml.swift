import Foundation
import Yams

enum EventPanelYamlError: LocalizedError {
    case invalidYamlStructure(String)
    case eventAlreadyExists(eventId: String)
    case eventsAlreadyExists(eventIds: [String])
    case eventNotFound(eventId: String)
    case missingRequiredField(String)

    var errorDescription: String? {
        switch self {
        case .invalidYamlStructure(let message):
            return "Invalid YAML structure: \(message)"
        case .eventAlreadyExists(let eventId):
            return "Event '\(eventId)' already exists"
        case .eventsAlreadyExists(let eventIds):
            return "Events already exists:\n- \(eventIds.joined(separator: "\n- "))"
        case .eventNotFound(let eventId):
            return "Event not found '\(eventId)'"
        case .missingRequiredField(let field):
            return "Invalid YAML. Missing required field: '\(field)'"
        }
    }
}

actor EventPanelYaml {
    private var config: EventPanelConfig
    private let path: String

    init(path: String) throws {
        self.path = path
        let yamlString = try String(contentsOfFile: path, encoding: .utf8)
        let decoder = YAMLDecoder()

        do {
            self.config = try decoder.decode(EventPanelConfig.self, from: yamlString)
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(let key, _):
                throw EventPanelYamlError.missingRequiredField(key.stringValue)
            case .typeMismatch(_, let context):
                throw EventPanelYamlError.invalidYamlStructure("Type mismatch for field '\(context.codingPath.last?.stringValue ?? "unknown")'")
            case .valueNotFound(_, let context):
                throw EventPanelYamlError.missingRequiredField(context.codingPath.last?.stringValue ?? "unknown")
            default:
                throw EventPanelYamlError.invalidYamlStructure(error.localizedDescription)
            }
        }
    }

    static func createDefault(at path: String, projectInfo: ProjectInfo) throws {
        let config = EventPanelConfig(
            source: projectInfo.source,
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

    func getSource() -> Source {
        return config.source
    }

    func getPlugin() -> Plugin {
        return config.plugin
    }

    func addEvent(_ event: Event) throws {
        if config.events.contains(where: { $0.id == event.id }) {
            throw EventPanelYamlError.eventAlreadyExists(eventId: event.id)
        }

        config.events.append(event)
        try save()
    }

    func addEvents(_ events: [Event]) throws -> Int {
        var newEvents: [Event] = []

        let existingIds = Set(config.events.map { $0.id })
        for event in events {
            if !existingIds.contains(event.id) {
                newEvents.append(event)
            }
        }

        config.events.append(contentsOf: newEvents)
        try save()

        return newEvents.count
    }

    func getEvents() -> [Event] {
        config.events
    }

    func updateEvent(eventId: String, version: Int) throws {
        guard let eventIndex = config.events.firstIndex(where: { $0.id == eventId }) else {
            throw EventPanelYamlError.eventNotFound(eventId: eventId)
        }

        config.events[eventIndex].version = version
        try save()
    }

    func getWorkspaceId() -> String? {
        config.workspaceId
    }

    func setWorkspaceId(_ id: String?) throws {
        config.workspaceId = id
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
    let source: Source
    let plugin: Plugin
}
