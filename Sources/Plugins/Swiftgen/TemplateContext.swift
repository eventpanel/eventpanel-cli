import Foundation
import PathKit

struct TemplateContext: Codable {
    let files: [File]
}

struct File: Codable {
    let document: Document
}

struct Document: Codable {
    let data: SwiftgenWorkspaceScheme
}
