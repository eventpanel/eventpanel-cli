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
        let dataType: TypeScriptDataType
        let required: Bool
        let value: String?
    }

    enum TypeScriptDataType: Codable {
        case string
        case int
        case float
        case bool
        case date

        case stringArray
        case intArray
        case floatArray
        case boolArray
        case dateArray

        case dictionary
        case dictionaryArray

        case custom(String)

        var stringValue: String {
            switch self {
            case .string: return "string"
            case .int: return "number"
            case .float: return "number"
            case .bool: return "boolean"
            case .date: return "string"
            case .stringArray: return "string[]"
            case .intArray: return "number[]"
            case .floatArray: return "number[]"
            case .boolArray: return "boolean[]"
            case .dateArray: return "string[]"
            case .dictionary: return "Record<string, unknown>"
            case .dictionaryArray: return "Record<string, unknown>[]"
            case .custom(let value): return value
            }
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let raw = try container.decode(String.self)
            switch raw {
            case "String": self = .string
            case "Int": self = .int
            case "Float": self = .float
            case "Bool": self = .bool
            case "Date": self = .date
            case "[String]": self = .stringArray
            case "[Integer]": self = .intArray
            case "[Float]": self = .floatArray
            case "[Bool]": self = .boolArray
            case "[Date]": self = .dateArray
            case "[String: Any]": self = .dictionary
            case "[[String: Any]]": self = .dictionaryArray
            default: self = .custom(raw)
            }
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(stringValue)
        }
    }

    struct CustomType: Codable {
        let name: String
        let type: String
        let dataType: TypeScriptDataType
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
            dataType: try TypeScriptGenWorkspaceScheme.TypeScriptDataType(from: customType.dataType),
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
            dataType: try TypeScriptGenWorkspaceScheme.TypeScriptDataType(from: propertyDefinition.dataType),
            required: propertyDefinition.required,
            value: propertyDefinition.value
        )
    }
}

extension TypeScriptGenWorkspaceScheme.TypeScriptDataType {
    init(from type: String) throws {
        switch type.uppercased() {
        case "STRING":
            self = .string
        case "BOOLEAN":
            self = .bool
        case "INTEGER":
            self = .int
        case "FLOAT":
            self = .float
        case "DATE":
            self = .date
        case "OBJECT":
            self = .dictionary
        case "[STRING]":
            self = .stringArray
        case "[BOOLEAN]":
            self = .boolArray
        case "[INTEGER]":
            self = .intArray
        case "[FLOAT]":
            self = .floatArray
        case "[DATE]":
            self = .dateArray
        case "[OBJECT]":
            self = .dictionaryArray
        default:
            self = .custom(type)
        }
    }
}
