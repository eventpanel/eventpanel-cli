import Foundation

struct SchemeResponse: Codable {
    let workspace: String
    let events: [EventDefinition]
    let customTypes: [CustomType]?
    let categories: [Category]?
}

struct EventDefinition: Codable {
    let id: String
    let name: String
    let description: String?
    let categoryIds: [String]?
    let sources: [String]?
    let properties: [PropertyDefinition]?
}

struct PropertyDefinition: Codable {
    let id: String
    let name: String
    let description: String
    let dataType: String
    let required: Bool
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case dataType
        case required
        case value
    }
}

struct CustomType: Codable {
    let name: String
    let type: String
    let dataType: String
    let cases: [String]
}

struct Category: Codable {
    let id: String
    let name: String
} 
