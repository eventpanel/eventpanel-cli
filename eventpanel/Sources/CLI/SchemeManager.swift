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
    private var scheme: SchemeResponse?
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
    
    func getEvent(id: String) -> EventDefinition? {
        scheme?.events.first { $0.id == id }
    }
    
    func getEvent(name: String) -> EventDefinition? {
        scheme?.events.first { $0.name == name }
    }
    
    func getEvents() -> [EventDefinition] {
        scheme?.events ?? []
    }
    
    func getEvents(inCategory categoryId: String) -> [EventDefinition] {
        scheme?.events.filter { $0.categoryIds?.contains(categoryId) ?? false } ?? []
    }
    
    func getCategory(id: String) -> Category? {
        scheme?.categories?.first { $0.id == id }
    }
    
    func getCategory(name: String) -> Category? {
        scheme?.categories?.first { $0.name == name }
    }
    
    func getCategories() -> [Category] {
        scheme?.categories ?? []
    }
    
    func getCustomType(name: String) -> CustomType? {
        scheme?.customTypes?.first { $0.name == name }
    }
    
    func getCustomTypes() -> [CustomType] {
        scheme?.customTypes ?? []
    }
    
    func getWorkspace() -> String? {
        scheme?.workspace
    }
    
    // MARK: - Private Methods
    
    private func loadScheme() throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        scheme = try decoder.decode(SchemeResponse.self, from: data)
    }
    
    func reload() throws {
        try loadScheme()
    }
} 
