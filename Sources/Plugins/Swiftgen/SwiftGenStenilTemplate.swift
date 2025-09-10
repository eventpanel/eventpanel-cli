import Foundation

struct SwiftGenStencilTemplate {
    let name: String
    let template: String
}

extension SwiftGenStencilTemplate {
    static func `default`() throws -> SwiftGenStencilTemplate {
        return SwiftGenStencilTemplate(
            name: "swiftgen-stenill-template",
            template: SwiftGenEmbeddedTemplate.template
        )
    }
}
