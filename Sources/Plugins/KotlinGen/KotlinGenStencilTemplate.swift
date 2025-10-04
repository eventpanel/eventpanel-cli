import Foundation

struct KotlinGenStencilTemplate {
    let name: String
    let template: String
}

extension KotlinGenStencilTemplate {
    static func `default`() throws -> KotlinGenStencilTemplate {
        return KotlinGenStencilTemplate(
            name: "kotlin",
            template: KotlinGenEmbeddedTemplate.template
        )
    }
}
