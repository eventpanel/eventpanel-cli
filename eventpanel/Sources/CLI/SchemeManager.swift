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

final class SchemeManager {
    private var scheme: WorkspaceScheme?
    private let fileManager: FileManager
    private let path: String
    
    static func read(fileManager: FileManager = .default) throws -> SchemeManager {
        let currentPath = fileManager.currentDirectoryPath
        let currentURL = URL(fileURLWithPath: currentPath)
        let schemePath = currentURL
            .appendingPathComponent(".eventpanel")
            .appendingPathComponent("scheme.json")
            .path

        guard fileManager.fileExists(atPath: schemePath) else {
            throw SchemeManagerError.schemeNotFound
        }
        
        return try SchemeManager(path: schemePath, fileManager: fileManager)
    }
    
    init(path: String, fileManager: FileManager = .default) throws {
        self.path = path
        self.fileManager = fileManager
        try loadScheme()
    }
    
    // MARK: - Public Methods
    
    func getEvent(id: String) -> WorkspaceScheme.EventDefinition? {
        scheme?.events.first { $0.id == id }
    }
    
    func getEvent(name: String) -> WorkspaceScheme.EventDefinition? {
        scheme?.events.first { $0.name == name }
    }
    
    func getEvents() -> [WorkspaceScheme.EventDefinition] {
        scheme?.events ?? []
    }
    
    func getEvents(inCategory categoryId: String) -> [WorkspaceScheme.EventDefinition] {
        scheme?.events.filter { $0.categoryIds?.contains(categoryId) ?? false } ?? []
    }
    
    func getCategory(id: String) -> WorkspaceScheme.Category? {
        scheme?.categories?.first { $0.id == id }
    }
    
    func getCategory(name: String) -> WorkspaceScheme.Category? {
        scheme?.categories?.first { $0.name == name }
    }
    
    func getCategories() -> [WorkspaceScheme.Category] {
        scheme?.categories ?? []
    }
    
    func getCustomType(name: String) -> WorkspaceScheme.CustomType? {
        scheme?.customTypes?.first { $0.name == name }
    }
    
    func getCustomTypes() -> [WorkspaceScheme.CustomType] {
        scheme?.customTypes ?? []
    }
    
    func getWorkspace() -> String? {
        scheme?.workspace
    }
    
    // MARK: - Private Methods

    @discardableResult
    func loadScheme() throws -> WorkspaceScheme {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let scheme = try decoder.decode(WorkspaceScheme.self, from: data)
        self.scheme = scheme
        return scheme
    }
    
    func reload() throws {
        try loadScheme()
    }
}
