import Foundation

struct TypeScriptGenParams: Codable {
    let namespace: String
    let eventClassName: String
    let documentation: Bool
    let shouldGenerateType: Bool
}
