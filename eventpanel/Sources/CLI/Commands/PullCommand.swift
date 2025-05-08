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

final class PullCommand {
    private let networkClient: NetworkClient
    private let eventPanelYaml: EventPanelYaml
    private let fileManager: FileManager
    
    init(networkClient: NetworkClient, eventPanelYaml: EventPanelYaml, fileManager: FileManager = .default) {
        self.networkClient = networkClient
        self.eventPanelYaml = eventPanelYaml
        self.fileManager = fileManager
    }
    
    func execute() async throws {
        ConsoleLogger.message("Fetching latest scheme...")

        // Fetch scheme from server
        let scheme = try await fetchScheme(
            events: eventPanelYaml.getEvents()
        )

        // Save scheme to disk
        try saveScheme(scheme)
        
        ConsoleLogger.success("Successfully pulled and stored scheme")
    }
    
    // MARK: - Private Methods
    
    private func fetchScheme(events: [Event]) async throws -> SchemeResponse {
        do {
            let response: Response<SchemeResponse> = try await networkClient.send(
                Request(
                    path: "api/external/events/generate/list",
                    method: .post,
                    body: SchemeRequest(
                        events: events.map {
                            EventDefenition(eventId: $0.name, version: $0.version ?? 1)
                        }
                    )
                )
            )
            return response.value
        } catch let error as APIError {
            throw PullCommandError.fetchFailed(error.localizedDescription)
        } catch {
            print(error)
            throw PullCommandError.fetchFailed(error.localizedDescription)
        }
    }
    
    private func saveScheme(_ scheme: SchemeResponse) throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
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

private struct SchemeRequest: Encodable {
    let events: [EventDefenition]
}

private struct EventDefenition: Codable {
    let eventId: String
    let version: Int
}
