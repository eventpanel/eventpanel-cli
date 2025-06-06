import Foundation
import PathKit

struct SwiftGenTemplateContext: Codable {
    struct File: Codable {
        let document: Document
    }

    struct Document: Codable {
        let data: SwiftGenWorkspaceScheme
    }

    let files: [File]
}
