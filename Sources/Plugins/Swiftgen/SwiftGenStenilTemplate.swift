import Foundation

struct SwiftGenStenillTemplate {
    let name: String
    let template: String
}

extension SwiftGenStenillTemplate {
    static func `default`() throws -> SwiftGenStenillTemplate {
        guard let path = Bundle.module.path(forResource: "swift5", ofType: "stencil") else {
            throw NSError(domain: "SwiftGenStenillTemplate", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find swift5.stencil template"])
        }
        return SwiftGenStenillTemplate(
            name: "swiftgen-stenill-template",
            template: try String(contentsOfFile: path)
        )
    }
}
