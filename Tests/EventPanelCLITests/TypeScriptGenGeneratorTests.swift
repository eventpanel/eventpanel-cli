import XCTest
import SnapshotTesting
@testable import eventpanel

final class TypeScriptGenGeneratorTests: XCTestCase {
    private var generator: TypeScriptGenGenerator!
    private var config: TypeScriptGenPlugin!

    override func setUp() {
        super.setUp()
        config = TypeScriptGenPlugin.make()
        generator = TypeScriptGenGenerator(config: config)
    }

    func testGenerateAnalyticsEvents() throws {
        let scheme = TypeScriptGenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event1",
                    name: "user_login",
                    description: "User logged in",
                    categoryIds: nil,
                    properties: [
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop1",
                            name: "user_id",
                            description: "User identifier",
                            dataType: .string,
                            required: true,
                            value: nil
                        ),
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop2",
                            name: "timestamp",
                            description: "Login timestamp",
                            dataType: .date,
                            required: false,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: nil,
            categories: nil
        )

        let template = try TypeScriptGenStencilTemplate.default()
        let result = try generator.generate(scheme: scheme, stencilTemplate: template)

        assertSnapshot(of: result, as: .txt, named: "testGenerateAnalyticsEvents")
    }

    func testGenerateAnalyticsEventsWithComplexProperties() throws {
        let scheme = TypeScriptGenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event1",
                    name: "user_action",
                    description: "User performed an action",
                    categoryIds: nil,
                    properties: [
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop1",
                            name: "action_type",
                            description: "Type of action",
                            dataType: .string,
                            required: true,
                            value: nil
                        ),
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop2",
                            name: "count",
                            description: "Number of items",
                            dataType: .int,
                            required: true,
                            value: nil
                        ),
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop3",
                            name: "tags",
                            description: "Associated tags",
                            dataType: .stringArray,
                            required: false,
                            value: nil
                        ),
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop4",
                            name: "metadata",
                            description: "Additional metadata",
                            dataType: .dictionary,
                            required: false,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: nil,
            categories: nil
        )

        let template = try TypeScriptGenStencilTemplate.default()
        let result = try generator.generate(scheme: scheme, stencilTemplate: template)

        assertSnapshot(of: result, as: .txt, named: "testGenerateAnalyticsEventsWithComplexProperties")
    }

    func testGenerateAnalyticsEventsWithCustomTypes() throws {
        let scheme = TypeScriptGenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event1",
                    name: "user_status_changed",
                    description: "User status changed",
                    categoryIds: nil,
                    properties: [
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop1",
                            name: "status",
                            description: "New user status",
                            dataType: .custom("UserStatus"),
                            required: true,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: [
                TypeScriptGenWorkspaceScheme.CustomType(
                    name: "UserStatus",
                    type: "enum",
                    dataType: .string,
                    cases: ["active", "inactive", "suspended"]
                )
            ],
            categories: nil
        )

        let template = try TypeScriptGenStencilTemplate.default()
        let result = try generator.generate(scheme: scheme, stencilTemplate: template)

        assertSnapshot(of: result, as: .txt, named: "testGenerateAnalyticsEventsWithCustomTypes")
    }

    func testGenerateAnalyticsEventsWithMultipleEvents() throws {
        let scheme = TypeScriptGenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event1",
                    name: "user_login",
                    description: "User logged in",
                    categoryIds: nil,
                    properties: [
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop1",
                            name: "user_id",
                            description: "User identifier",
                            dataType: .string,
                            required: true,
                            value: nil
                        )
                    ]
                ),
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event2",
                    name: "user_logout",
                    description: "User logged out",
                    categoryIds: nil,
                    properties: nil
                )
            ],
            customTypes: nil,
            categories: nil
        )

        let template = try TypeScriptGenStencilTemplate.default()
        let result = try generator.generate(scheme: scheme, stencilTemplate: template)

        assertSnapshot(of: result, as: .txt, named: "testGenerateAnalyticsEventsWithMultipleEvents")
    }

    func testGenerateAnalyticsEventsWithCategories() throws {
        let scheme = TypeScriptGenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event1",
                    name: "user_login",
                    description: "User logged in",
                    categoryIds: ["auth"],
                    properties: [
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop1",
                            name: "user_id",
                            description: "User identifier",
                            dataType: .string,
                            required: true,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: nil,
            categories: [
                TypeScriptGenWorkspaceScheme.Category(
                    id: "auth",
                    name: "Authentication",
                    description: "Authentication related events"
                )
            ]
        )

        let template = try TypeScriptGenStencilTemplate.default()
        let result = try generator.generate(scheme: scheme, stencilTemplate: template)

        assertSnapshot(of: result, as: .txt, named: "testGenerateAnalyticsEventsWithCategories")
    }

    func testGenerateAnalyticsEventsWithEmptyDescription() throws {
        let scheme = TypeScriptGenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event1",
                    name: "user_action",
                    description: "",
                    categoryIds: nil,
                    properties: [
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop1",
                            name: "action",
                            description: "",
                            dataType: .string,
                            required: true,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: nil,
            categories: nil
        )

        let template = try TypeScriptGenStencilTemplate.default()
        let result = try generator.generate(scheme: scheme, stencilTemplate: template)

        assertSnapshot(of: result, as: .txt, named: "testEventWithEmptyDescription")
    }

    func testGenerateAnalyticsEventsWithEmptyProperties() throws {
        let scheme = TypeScriptGenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event1",
                    name: "simple_event",
                    description: "A simple event with no properties",
                    categoryIds: nil,
                    properties: []
                )
            ],
            customTypes: nil,
            categories: nil
        )

        let template = try TypeScriptGenStencilTemplate.default()
        let result = try generator.generate(scheme: scheme, stencilTemplate: template)

        assertSnapshot(of: result, as: .txt, named: "testEventWithEmptyProperties")
    }

    func testGenerateAnalyticsEventsWithPropertyWithEmptyDescription() throws {
        let scheme = TypeScriptGenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event1",
                    name: "user_action",
                    description: "User performed an action",
                    categoryIds: nil,
                    properties: [
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop1",
                            name: "action",
                            description: "",
                            dataType: .string,
                            required: true,
                            value: nil
                        ),
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop2",
                            name: "user_id",
                            description: "User identifier",
                            dataType: .string,
                            required: true,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: nil,
            categories: nil
        )

        let template = try TypeScriptGenStencilTemplate.default()
        let result = try generator.generate(scheme: scheme, stencilTemplate: template)

        assertSnapshot(of: result, as: .txt, named: "testEventWithPropertyWithEmptyDescription")
    }

    func testGenerateAnalyticsEventsWithoutTypeDefinition() throws {
        let configWithoutType = TypeScriptGenPlugin(
            outputFilePath: "GeneratedAnalyticsEvents.ts",
            namespace: "AnalyticsEvents",
            eventClassName: "AnalyticsEvent",
            documentation: true,
            shouldGenerateType: false
        )
        let generatorWithoutType = TypeScriptGenGenerator(config: configWithoutType)

        let scheme = TypeScriptGenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event1",
                    name: "user_login",
                    description: "User logged in",
                    categoryIds: nil,
                    properties: [
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop1",
                            name: "user_id",
                            description: "User identifier",
                            dataType: .string,
                            required: true,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: nil,
            categories: nil
        )

        let template = try TypeScriptGenStencilTemplate.default()
        let result = try generatorWithoutType.generate(scheme: scheme, stencilTemplate: template)

        assertSnapshot(of: result, as: .txt, named: "testWithoutTypeDefinition")
    }

    func testUncategorisedEvents() throws {
        let scheme = TypeScriptGenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                TypeScriptGenWorkspaceScheme.EventDefinition(
                    id: "event1",
                    name: "uncategorised_event",
                    description: "An event without category",
                    categoryIds: [],
                    properties: [
                        TypeScriptGenWorkspaceScheme.PropertyDefinition(
                            id: "prop1",
                            name: "value",
                            description: "Some value",
                            dataType: .string,
                            required: true,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: nil,
            categories: [
                TypeScriptGenWorkspaceScheme.Category(
                    id: "auth",
                    name: "Authentication",
                    description: "Authentication related events"
                )
            ]
        )

        let template = try TypeScriptGenStencilTemplate.default()
        let result = try generator.generate(scheme: scheme, stencilTemplate: template)

        assertSnapshot(of: result, as: .txt, named: "testUncategorisedEvents")
    }
}
