import Foundation
import Yams

final class EventPanelYaml {
    private var yaml: [String: Any]
    private let path: String
    
    enum Error: Swift.Error {
        case invalidYamlStructure(String)
        case targetNotFound(String)
        case eventAlreadyExists(String, String)
    }
    
    init(path: String) throws {
        self.path = path
        let yamlString = try String(contentsOfFile: path, encoding: .utf8)
        guard let parsedYaml = try Yams.load(yaml: yamlString) as? [String: Any] else {
            throw Error.invalidYamlStructure("Invalid YAML structure")
        }
        self.yaml = parsedYaml
    }
    
    static func createDefault(
        at path: String,
        projectInfo: ProjectInfo
    ) throws {
        let template = """
        # EventPanel configuration file

        # Global settings
        platform: \(projectInfo.platform)
        minimum_version: '\(projectInfo.defaultVersion)'

        # Target configurations
        targets:
          # Main app target
          \(projectInfo.name):
            events:
            #  - name: "App Launch"
            #  - name: "User Sign In"
            #  - name: "Purchase Complete"
            #    version: "2"

          # Watch app target
          # \(projectInfo.name)Watch:
          #   events:
          #     - name: "Watch App Launch"
          #     - name: "Workout Started"

          # Widget target
          # \(projectInfo.name)Widget:
          #   events:
          #     - name: "Widget Viewed"

        """
        try template.write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    func addEvent(name: String, to targetName: String) throws {
        // Get or create targets dictionary
        var targets = yaml["targets"] as? [String: Any] ?? [:]
        guard var target = targets[targetName] as? [String: Any] else {
            throw Error.targetNotFound("Target '\(targetName)' not found")
        }
        
        var events = target["events"] as? [[String: Any]] ?? []
        
        // Check if event already exists
        if events.contains(where: { ($0["name"] as? String) == name }) {
            throw Error.eventAlreadyExists(name, targetName)
        }
        
        // Add new event
        events.append(["name": name])
        
        // Update the YAML structure
        target["events"] = events
        targets[targetName] = target
        yaml["targets"] = targets
        
        try save()
    }
    
    private func save() throws {
        let updatedYaml = try Yams.dump(object: yaml)
        try updatedYaml.write(toFile: path, atomically: true, encoding: .utf8)
    }
}

// Move ProjectInfo here since it's related to YAML configuration
struct ProjectInfo {
    let name: String
    let platform: String
    let defaultVersion: String
} 
