import Foundation

struct SwiftGenStencilTemplate {
    let name: String
    let template: String
}

extension SwiftGenStencilTemplate {
    static func `default`() throws -> SwiftGenStencilTemplate {
        guard let path = Bundle.module.path(forResource: "swift5", ofType: "stencil") else {
            throw NSError(domain: "SwiftGenStencilTemplate", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find swift5.stencil template"])
        }
        return SwiftGenStencilTemplate(
            name: "swiftgen-stenill-template",
            template: try String(contentsOfFile: path)
        )
    }
}
