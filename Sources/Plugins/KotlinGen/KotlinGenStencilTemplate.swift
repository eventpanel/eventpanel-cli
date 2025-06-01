import Foundation

struct KotlinGenStencilTemplate {
    let name: String
    let template: String
}

extension KotlinGenStencilTemplate {
    static func `default`() throws -> KotlinGenStencilTemplate {
        guard let path = Bundle.module.path(forResource: "kotlin", ofType: "stencil") else {
            throw NSError(
                domain: "KotlinGenStencilTemplate",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Could not find kotlin.stencil template"]
            )
        }
        return KotlinGenStencilTemplate(
            name: "kotlin",
            template: try String(contentsOfFile: path)
        )
    }
} 
