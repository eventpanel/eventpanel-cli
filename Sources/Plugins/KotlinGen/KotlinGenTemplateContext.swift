import Foundation
import PathKit

struct KotlinGenTemplateContext: Codable {
    struct File: Codable {
        let document: Document
    }

    struct Document: Codable {
        let data: KotlinGenWorkspaceScheme
    }

    let files: [File]
}
