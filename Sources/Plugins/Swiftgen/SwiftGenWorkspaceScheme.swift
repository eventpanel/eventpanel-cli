import Foundation

struct SwiftGenWorkspaceScheme: Codable {
    let workspace: String
    let events: [EventDefinition]
    let customTypes: [CustomType]?
    let categories: [Category]?

    struct EventDefinition: Codable {
        let id: String
        let name: String
        let description: String?
        let categoryIds: [String]?
        let properties: [PropertyDefinition]?
    }

    struct PropertyDefinition: Codable {
        let id: String
        let name: String
        let description: String
        let dataType: String
        let required: Bool
        let value: String?
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
        let description: String?
    }
}

extension SwiftGenWorkspaceScheme {
    init(from scheme: WorkspaceScheme) throws {
        self.init(
            workspace: scheme.workspace,
            events: try scheme.events.map(SwiftGenWorkspaceScheme.EventDefinition.init(from:)),
            customTypes: try scheme.customTypes?.map(CustomType.init(from:)),
            categories: scheme.categories?.map(Category.init(from:))
        )
    }
}

extension SwiftGenWorkspaceScheme.Category {
    init(from category: WorkspaceScheme.Category) {
        self.init(id: category.id, name: category.name, description: category.description)
    }
}

extension SwiftGenWorkspaceScheme.EventDefinition {
    init(from event: WorkspaceScheme.EventDefinition) throws {
        self.init(
            id: event.id,
            name: event.name,
            description: event.description,
            categoryIds: event.categoryIds,
            properties: try event.properties?.map(SwiftGenWorkspaceScheme.PropertyDefinition.init(from:))
        )
    }
}

extension SwiftGenWorkspaceScheme.CustomType {
    init(from customType: WorkspaceScheme.CustomType) throws {
        self.init(
            name: customType.name,
            type: customType.type,
            dataType: customType.dataType.swiftType,
            cases: customType.values
        )
    }
}

extension SwiftGenWorkspaceScheme.PropertyDefinition {
    init(from propertyDefinition: WorkspaceScheme.PropertyDefinition) throws {
        self.init(
            id: propertyDefinition.id,
            name: propertyDefinition.name,
            description: propertyDefinition.description,
            dataType: propertyDefinition.dataType.swiftType,
            required: propertyDefinition.required,
            value: propertyDefinition.value
        )
    }
}

// MARK: - Swift Type Mapping
extension EventPanelDataType {
    var swiftType: String {
        switch self {
        case .string: return "String"
        case .stringList: return "[String]"
        case .integer: return "Int"
        case .integerList: return "[Integer]"
        case .float: return "Float"
        case .floatList: return "[Float]"
        case .boolean: return "Bool"
        case .booleanList: return "[Bool]"
        case .date: return "Date"
        case .dateList: return "[Date]"
        case .object: return "[String: Any]"
        case .objectList: return "[[String: Any]]"
        case .custom(let value): return value
        }
    }
}
