import Foundation

func codableToDictionary<T: Codable>(
    _ value: T,
    keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
) throws -> [String: Any]? {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = keyEncodingStrategy
    let data = try encoder.encode(value)
    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
    return jsonObject as? [String: Any]
}
