import Foundation

struct EventPanelConfig: Codable {
    var workspaceId: String?
    let source: Source
    let plugin: Plugin
    var events: [Event]

    enum CodingKeys: String, CodingKey {
        case workspaceId
        case source
        case plugin
        case events
    }
    
    init(source: Source, plugin: Plugin, events: [Event] = []) {
        self.source = source
        self.plugin = plugin
        self.events = events
    }
}

struct Event: Codable {
    var id: String
    var version: Int?

    init(id: String, version: Int? = nil) {
        self.id = id
        self.version = version
    }
}
