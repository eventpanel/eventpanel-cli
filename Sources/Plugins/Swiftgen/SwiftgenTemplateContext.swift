import Foundation
import PathKit

struct SwiftgenTemplateContext: Codable {
    struct File: Codable {
        let document: Document
    }

    struct Document: Codable {
        let data: SwiftgenWorkspaceScheme
    }

    let files: [File]
}
