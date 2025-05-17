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
    var name: String
    var version: Int?

    init(name: String, version: Int? = nil) {
        self.name = name
        self.version = version
    }
}
