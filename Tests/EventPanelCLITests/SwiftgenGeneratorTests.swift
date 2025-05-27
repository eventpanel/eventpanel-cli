import XCTest
import SnapshotTesting
@testable import eventpanel

final class SwiftgenGeneratorTests: XCTestCase {
    func testGenerateAnalyticsEvents() throws {
        // Given
        let config = SwiftgenPlugin.default
        let generator = SwiftgenGenerator(config: config)
        
        let scheme = SwiftgenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                .init(
                    id: "userLogin",
                    name: "User Login",
                    description: "User logged in to the app",
                    categoryIds: ["user"],
                    properties: [
                        .init(
                            id: "login_method",
                            name: "login_method",
                            description: "Login method used",
                            dataType: .string,
                            required: true,
                            value: nil
                        ),
                        .init(
                            id: "is_successful",
                            name: "is_successful",
                            description: "Whether login was successful",
                            dataType: .bool,
                            required: true,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: [
                .init(
                    name: "method",
                    type: "enum",
                    dataType: .string,
                    cases: ["email", "google", "apple"]
                )
            ],
            categories: [
                .init(id: "user", name: "User"),
                .init(id: "app", name: "App")
            ]
        )
        
        let stencilTemplate = try SwiftgenStenillTemplate.default()
        
        // When
        let output = try generator.generate(scheme: scheme, stencilTemplate: stencilTemplate)
        
        // Then
        assertSnapshot(of: output, as: .lines)
    }
    
    func testGenerateAnalyticsEventsWithMultipleEvents() throws {
        // Given
        let config = SwiftgenPlugin.default
        let generator = SwiftgenGenerator(config: config)
        
        let scheme = SwiftgenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                .init(
                    id: "onboardingStart",
                    name: "Onboarding Start",
                    description: "User started the onboarding process",
                    categoryIds: ["onboarding"],
                    properties: [
                        .init(
                            id: "source",
                            name: "source",
                            description: "Where the onboarding was initiated from",
                            dataType: .string,
                            required: true,
                            value: nil
                        )
                    ]
                ),
                .init(
                    id: "onboardingComplete",
                    name: "Onboarding Complete",
                    description: "User completed the onboarding process",
                    categoryIds: ["onboarding"],
                    properties: [
                        .init(
                            id: "completion_time",
                            name: "completion_time",
                            description: "Time taken to complete onboarding in seconds",
                            dataType: .int,
                            required: true,
                            value: nil
                        ),
                        .init(
                            id: "skipped_steps",
                            name: "skipped_steps",
                            description: "Number of steps skipped during onboarding",
                            dataType: .int,
                            required: false,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: [],
            categories: [
                .init(id: "onboarding", name: "Onboarding")
            ]
        )
        
        let stencilTemplate = try SwiftgenStenillTemplate.default()
        
        // When
        let output = try generator.generate(scheme: scheme, stencilTemplate: stencilTemplate)
        
        // Then
        assertSnapshot(of: output, as: .lines)
    }
    
    func testGenerateAnalyticsEventsWithComplexProperties() throws {
        // Given
        let config = SwiftgenPlugin.default
        let generator = SwiftgenGenerator(config: config)
        
        let scheme = SwiftgenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                .init(
                    id: "productView",
                    name: "Product View",
                    description: "User viewed a product",
                    categoryIds: ["ecommerce"],
                    properties: [
                        .init(
                            id: "product_id",
                            name: "product_id",
                            description: "Unique identifier of the product",
                            dataType: .string,
                            required: true,
                            value: nil
                        ),
                        .init(
                            id: "product_price",
                            name: "product_price",
                            description: "Price of the product",
                            dataType: .float,
                            required: true,
                            value: nil
                        ),
                        .init(
                            id: "currency",
                            name: "currency",
                            description: "Currency code",
                            dataType: .string,
                            required: true,
                            value: "USD"
                        ),
                        .init(
                            id: "is_on_sale",
                            name: "is_on_sale",
                            description: "Whether the product is on sale",
                            dataType: .bool,
                            required: false,
                            value: "false"
                        ),
                        .init(
                            id: "discount_percentage",
                            name: "discount_percentage",
                            description: "Discount percentage if on sale",
                            dataType: .float,
                            required: false,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: [],
            categories: [
                .init(id: "ecommerce", name: "E-commerce")
            ]
        )
        
        let stencilTemplate = try SwiftgenStenillTemplate.default()
        
        // When
        let output = try generator.generate(scheme: scheme, stencilTemplate: stencilTemplate)
        
        // Then
        assertSnapshot(of: output, as: .lines)
    }
    
    func testGenerateAnalyticsEventsWithCustomTypes() throws {
        // Given
        let config = SwiftgenPlugin.default
        let generator = SwiftgenGenerator(config: config)
        
        let scheme = SwiftgenWorkspaceScheme(
            workspace: "test-workspace",
            events: [
                .init(
                    id: "paymentProcess",
                    name: "Payment Process",
                    description: "User processed a payment",
                    categoryIds: ["payment"],
                    properties: [
                        .init(
                            id: "payment_method",
                            name: "payment_method",
                            description: "Method of payment",
                            dataType: .string,
                            required: true,
                            value: nil
                        ),
                        .init(
                            id: "payment_status",
                            name: "payment_status",
                            description: "Status of the payment",
                            dataType: .string,
                            required: true,
                            value: nil
                        )
                    ]
                )
            ],
            customTypes: [
                .init(
                    name: "paymentMethod",
                    type: "enum",
                    dataType: .string,
                    cases: ["credit_card", "paypal", "apple_pay", "google_pay"]
                ),
                .init(
                    name: "paymentStatus",
                    type: "enum",
                    dataType: .string,
                    cases: ["pending", "completed", "failed", "refunded"]
                )
            ],
            categories: [
                .init(id: "payment", name: "Payment")
            ]
        )
        
        let stencilTemplate = try SwiftgenStenillTemplate.default()
        
        // When
        let output = try generator.generate(scheme: scheme, stencilTemplate: stencilTemplate)
        
        // Then
        assertSnapshot(of: output, as: .lines)
    }
} 
