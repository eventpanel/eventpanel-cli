import Foundation
import PathKit

struct TypeScriptGenTemplateContext: Codable {
    struct File: Codable {
        let document: Document
    }

    struct Document: Codable {
        let data: TypeScriptGenWorkspaceScheme
    }

    let files: [File]
}
