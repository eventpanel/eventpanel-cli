import Foundation
import Get

enum PullCommandError: LocalizedError {
    case fetchFailed(String)
    case invalidResponse
    case saveFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return "Failed to fetch scheme: \(message)"
        case .invalidResponse:
            return "Invalid response from server"
        case .saveFailed(let message):
            return "Failed to save scheme: \(message)"
        }
    }
}

final class PullCommand: Command {
    let name = "pull"
    let description = "Fetch and store the latest scheme from the server"
    
    private let networkClient: NetworkClient
    private let fileManager: FileManager
    
    init(networkClient: NetworkClient, fileManager: FileManager = .default) {
        self.networkClient = networkClient
        self.fileManager = fileManager
    }
    
    func execute(with arguments: [String]) async throws {
        ConsoleLogger.message("Fetching latest scheme...")
        
        // Fetch scheme from server
        let scheme = try await fetchScheme()
        
        // Save scheme to disk
        try saveScheme(scheme)
        
        ConsoleLogger.success("Successfully pulled and stored scheme")
    }
    
    // MARK: - Private Methods
    
    private func fetchScheme() async throws -> SchemeResponse {
        do {
            let response: Response<SchemeResponse> = try await networkClient.send(
                Request(path: "api/external/events/generate/all", method: .post)
            )
            return response.value
        } catch let error as APIError {
            throw PullCommandError.fetchFailed(error.localizedDescription)
        } catch {
            throw PullCommandError.fetchFailed(error.localizedDescription)
        }
    }
    
    private func saveScheme(_ scheme: SchemeResponse) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        do {
            let data = try encoder.encode(scheme)
            
            // Create .eventpanel directory if it doesn't exist
            let eventPanelDir = try getEventPanelDirectory()
            try fileManager.createDirectory(
                at: eventPanelDir,
                withIntermediateDirectories: true,
                attributes: nil
            )
            
            // Save scheme.json
            let schemeURL = eventPanelDir.appendingPathComponent("scheme.json")
            try data.write(to: schemeURL)
            
            // Reload scheme manager if it exists
            if let schemeManager = try? SchemeManager.read(fileManager: fileManager) {
                try schemeManager.reload()
            }
            
        } catch {
            throw PullCommandError.saveFailed(error.localizedDescription)
        }
    }
    
    private func getEventPanelDirectory() throws -> URL {
        let currentPath = fileManager.currentDirectoryPath
        return URL(fileURLWithPath: (currentPath as NSString)
            .appendingPathComponent(".eventpanel"))
    }
} 
