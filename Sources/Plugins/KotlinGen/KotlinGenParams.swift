import Foundation

struct KotlinGenParams: Codable {
    let packageName: String
    let eventClassName: String
    let documentation: Bool
    let shouldGenerateType: Bool
}
