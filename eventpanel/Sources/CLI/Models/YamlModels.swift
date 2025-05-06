import Foundation

struct EventPanelConfig: Codable {
    /// Global settings
    var platform: Platform
    var plugin: Plugin
    var events: [Event]

    enum CodingKeys: String, CodingKey {
        case platform
        case plugin
        case events
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
