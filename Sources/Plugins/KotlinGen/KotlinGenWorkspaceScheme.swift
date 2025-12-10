import Foundation

struct KotlinGenWorkspaceScheme: Codable {
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

extension KotlinGenWorkspaceScheme {
    init(from scheme: WorkspaceScheme) throws {
        self.init(
            workspace: scheme.workspace,
            events: try scheme.events.map(KotlinGenWorkspaceScheme.EventDefinition.init(from:)),
            customTypes: try scheme.customTypes?.map(CustomType.init(from:)),
            categories: scheme.categories?.map(Category.init(from:))
        )
    }
}

extension KotlinGenWorkspaceScheme.Category {
    init(from category: WorkspaceScheme.Category) {
        self.init(id: category.id, name: category.name, description: category.description)
    }
}

extension KotlinGenWorkspaceScheme.EventDefinition {
    init(from event: WorkspaceScheme.EventDefinition) throws {
        self.init(
            id: event.id,
            name: event.name,
            description: event.description,
            categoryIds: event.categoryIds,
            properties: try event.properties?.map(KotlinGenWorkspaceScheme.PropertyDefinition.init(from:))
        )
    }
}

extension KotlinGenWorkspaceScheme.CustomType {
    init(from customType: WorkspaceScheme.CustomType) throws {
        self.init(
            name: customType.name,
            type: customType.type,
            dataType: customType.dataType.kotlinType,
            cases: customType.values
        )
    }
}

extension KotlinGenWorkspaceScheme.PropertyDefinition {
    init(from propertyDefinition: WorkspaceScheme.PropertyDefinition) throws {
        self.init(
            id: propertyDefinition.id,
            name: propertyDefinition.name,
            description: propertyDefinition.description,
            dataType: propertyDefinition.dataType.kotlinType,
            required: propertyDefinition.required,
            value: propertyDefinition.value
        )
    }
}
// MARK: - Kotlin Type Mapping
extension EventPanelDataType {
    var kotlinType: String {
        switch self {
        case .string: return "String"
        case .stringList: return "List<String>"
        case .integer: return "Int"
        case .integerList: return "List<Int>"
        case .float: return "Double"
        case .floatList: return "List<Double>"
        case .boolean: return "Boolean"
        case .booleanList: return "List<Boolean>"
        case .date: return "Date"
        case .dateList: return "List<Date>"
        case .object: return "Map<String, Any>"
        case .objectList: return "List<Map<String, Any>>"
        case .custom(let value): return value
        }
    }
}

