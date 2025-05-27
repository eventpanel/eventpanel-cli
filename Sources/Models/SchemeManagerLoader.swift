import Foundation

enum SchemeManagerError: LocalizedError {
    case schemeNotFound
    case invalidScheme(String)

    var errorDescription: String? {
        switch self {
        case .schemeNotFound:
            return "Scheme file not found. Run 'eventpanel pull' to fetch the latest scheme."
        case .invalidScheme(let message):
            return "Invalid scheme data: \(message)"
        }
    }
}

protocol SchemeManagerLoader {
    func read() throws -> WorkspaceScheme
}

final class FileSchemeManagerLoader: SchemeManagerLoader, @unchecked Sendable {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func read() throws -> WorkspaceScheme {
        let currentPath = fileManager.currentDirectoryPath
        let currentURL = URL(fileURLWithPath: currentPath)
        let schemePath = currentURL
            .appendingPathComponent(".eventpanel")
            .appendingPathComponent("scheme.json")
            .path

        guard fileManager.fileExists(atPath: schemePath) else {
            throw SchemeManagerError.schemeNotFound
        }

        return try loadScheme(path: schemePath)
    }

    @discardableResult
    private func loadScheme(path: String) throws -> WorkspaceScheme {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let scheme = try decoder.decode(WorkspaceScheme.self, from: data)
        return scheme
    }
}
