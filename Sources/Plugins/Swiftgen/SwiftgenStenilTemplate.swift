import Foundation

struct SwiftgenStenillTemplate {
    let name: String
    let template: String
}

extension SwiftgenStenillTemplate {
    static func `default`() throws -> SwiftgenStenillTemplate {
        guard let path = Bundle.module.path(forResource: "swift5", ofType: "stencil") else {
            throw NSError(domain: "SwiftgenStenillTemplate", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find swift5.stencil template"])
        }
        return SwiftgenStenillTemplate(
            name: "swiftgen-stenill-template",
            template: try String(contentsOfFile: path)
        )
    }
}
