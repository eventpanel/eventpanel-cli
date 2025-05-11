//
//  WorkspaceScheme 2.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 11.05.2025.
//

import Foundation

struct SwiftgenWorkspaceScheme: Codable {
    let workspace: String
    let events: [EventDefinition]
    let customTypes: [CustomType]?
    let categories: [Category]?

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
        let dataType: SwiftDataType
        let required: Bool
        let value: String?
    }

    enum SwiftDataType: String, Codable {
        case string = "String"
        case int = "Int"
        case float = "Float"
        case bool = "Bool"
        case date = "Date"

        case stringArray = "[String]"
        case intArray = "[Integer]"
        case floatArray = "[Float]"
        case boolArray = "[Bool]"
        case dateArray = "[Date]"

        case dictionary = "[String: Any]"
        case dictionaryArray = "[[String: Any]]"
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
}

extension SwiftgenWorkspaceScheme {
    init(from scheme: WorkspaceScheme) throws {
        self.init(
            workspace: scheme.workspace,
            events: try scheme.events.map(SwiftgenWorkspaceScheme.EventDefinition.init(from:)),
            customTypes: try scheme.customTypes?.map(CustomType.init(from:)),
            categories: scheme.categories?.map(Category.init(from:))
        )
    }
}

extension SwiftgenWorkspaceScheme.Category {
    init(from category: WorkspaceScheme.Category) {
        self.init(id: category.id, name: category.name)
    }
}

extension SwiftgenWorkspaceScheme.EventDefinition {
    init(from event: WorkspaceScheme.EventDefinition) throws {
        self.init(
            id: event.id,
            name: event.name,
            description: event.description,
            categoryIds: event.categoryIds,
            sources: event.sources,
            properties: try event.properties?.map(SwiftgenWorkspaceScheme.PropertyDefinition.init(from:))
        )
    }
}

extension SwiftgenWorkspaceScheme.CustomType {
    init(from customType: WorkspaceScheme.CustomType) throws {
        self.init(
            name: customType.name,
            type: customType.type,
            dataType: customType.dataType,
            cases: customType.cases
        )
    }
}

extension SwiftgenWorkspaceScheme.PropertyDefinition {
    init(from propertyDefinition: WorkspaceScheme.PropertyDefinition) throws {
        self.init(
            id: propertyDefinition.id,
            name: propertyDefinition.name,
            description: propertyDefinition.description,
            dataType: try SwiftgenWorkspaceScheme.SwiftDataType(from: propertyDefinition.dataType),
            required: propertyDefinition.required,
            value: propertyDefinition.value
        )
    }
}

extension SwiftgenWorkspaceScheme.SwiftDataType {
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
            throw NSError(
                domain: "SwiftDataType",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Unsupported data type: \(type)"]
            )
        }
    }
}
