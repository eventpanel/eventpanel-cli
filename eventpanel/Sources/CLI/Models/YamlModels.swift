import Foundation

struct EventPanelConfig: Codable {
    /// Global settings
    var platform: Platform
    var minimumVersion: String
    var targets: [String: Target]
    
    enum CodingKeys: String, CodingKey {
        case platform
        case minimumVersion = "minimum_version"
        case targets
    }
}

struct Target: Codable {
    var events: [Event]
}

struct Event: Codable {
    var name: String
    var version: Int?

    init(name: String, version: Int? = nil) {
        self.name = name
        self.version = version
    }
} 
