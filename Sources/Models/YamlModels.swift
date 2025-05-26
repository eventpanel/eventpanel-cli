import Foundation

struct EventPanelConfig: Codable {
    /// Global settings
    let language: Language
    let plugin: Plugin
    var events: [Event]

    enum CodingKeys: String, CodingKey {
        case language
        case plugin
        case events
    }
    
    init(language: Language, plugin: Plugin, events: [Event] = []) {
        self.language = language
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
