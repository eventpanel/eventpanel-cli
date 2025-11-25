import Foundation

struct TypeScriptGenParams: Codable {
    let namespace: String
    let publicAccess: Bool
    let eventClassName: String
    let documentation: Bool
    let shouldGenerateType: Bool
}
