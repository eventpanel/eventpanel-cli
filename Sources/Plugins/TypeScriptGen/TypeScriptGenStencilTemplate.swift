import Foundation

struct TypeScriptGenStencilTemplate {
    let name: String
    let template: String
}

extension TypeScriptGenStencilTemplate {
    static func `default`() throws -> TypeScriptGenStencilTemplate {
        return TypeScriptGenStencilTemplate(
            name: "typescript",
            template: TypeScriptGenEmbeddedTemplate.template
        )
    }
}
