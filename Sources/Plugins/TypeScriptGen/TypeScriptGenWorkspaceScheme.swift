import Foundation

struct TypeScriptGenWorkspaceScheme: Codable {
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

extension TypeScriptGenWorkspaceScheme {
    init(from scheme: WorkspaceScheme) throws {
        self.init(
            workspace: scheme.workspace,
            events: try scheme.events.map(TypeScriptGenWorkspaceScheme.EventDefinition.init(from:)),
            customTypes: try scheme.customTypes?.map(CustomType.init(from:)),
            categories: scheme.categories?.map(Category.init(from:))
        )
    }
}

extension TypeScriptGenWorkspaceScheme.Category {
    init(from category: WorkspaceScheme.Category) {
        self.init(id: category.id, name: category.name, description: category.description)
    }
}

extension TypeScriptGenWorkspaceScheme.EventDefinition {
    init(from event: WorkspaceScheme.EventDefinition) throws {
        self.init(
            id: event.id,
            name: event.name,
            description: event.description,
            categoryIds: event.categoryIds,
            properties: try event.properties?.map(TypeScriptGenWorkspaceScheme.PropertyDefinition.init(from:))
        )
    }
}

extension TypeScriptGenWorkspaceScheme.CustomType {
    init(from customType: WorkspaceScheme.CustomType) throws {
        self.init(
            name: customType.name,
            type: customType.type,
            dataType: customType.dataType.typeScriptType,
            cases: customType.values
        )
    }
}

extension TypeScriptGenWorkspaceScheme.PropertyDefinition {
    init(from propertyDefinition: WorkspaceScheme.PropertyDefinition) throws {
        self.init(
            id: propertyDefinition.id,
            name: propertyDefinition.name,
            description: propertyDefinition.description,
            dataType: propertyDefinition.dataType.typeScriptType,
            required: propertyDefinition.required,
            value: propertyDefinition.value
        )
    }
}

// MARK: - TypeScript Type Mapping
extension EventPanelDataType {
    var typeScriptType: String {
        switch self {
        case .string: return "string"
        case .stringList: return "string[]"
        case .integer: return "number"
        case .integerList: return "number[]"
        case .float: return "number"
        case .floatList: return "number[]"
        case .boolean: return "boolean"
        case .booleanList: return "boolean[]"
        case .date: return "string"
        case .dateList: return "string[]"
        case .object: return "Record<string, unknown>"
        case .objectList: return "Record<string, unknown>[]"
        case .custom(let value): return value
        }
    }
}
