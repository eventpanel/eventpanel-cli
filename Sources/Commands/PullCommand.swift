import Foundation
import Get

enum PullCommandError: LocalizedError {
    case fetchFailed(String)
    case invalidResponse
    case saveFailed(String)
    case eventsAreMissing
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return "Failed to fetch scheme: \(message)"
        case .invalidResponse:
            return "Invalid response from server"
        case .saveFailed(let message):
            return "Failed to save scheme: \(message)"
        case .eventsAreMissing:
            return "No events found in EventPanel.yaml"
        }
    }
}

final class PullCommand {
    private let apiService: EventPanelAPIService
    private let eventPanelYaml: EventPanelYaml
    private let fileManager: FileManager
    
    init(apiService: EventPanelAPIService, eventPanelYaml: EventPanelYaml, fileManager: FileManager) {
        self.apiService = apiService
        self.eventPanelYaml = eventPanelYaml
        self.fileManager = fileManager
    }
    
    func execute() async throws {
        ConsoleLogger.message("Fetching latest scheme...")

        // Validate events
        let events = await eventPanelYaml.getEvents()
        guard !events.isEmpty else {
            throw PullCommandError.eventsAreMissing
        }

        // Fetch scheme from server
        let scheme = try await fetchScheme(events: events)

        // Save scheme to disk
        try saveScheme(scheme)
        
        ConsoleLogger.success("Successfully pulled and stored scheme")
    }
    
    // MARK: - Private Methods
    
    private func fetchScheme(events: [Event]) async throws -> WorkspaceScheme {
        do {
            let eventDefinitions = events.map {
                LocalEventDefenitionData(eventId: $0.id, version: $0.version ?? 1)
            }
            return try await apiService.generateScheme(events: eventDefinitions)
        } catch let error as APIError {
            throw PullCommandError.fetchFailed(error.localizedDescription)
        } catch {
            throw PullCommandError.fetchFailed(error.localizedDescription)
        }
    }
    
    private func saveScheme(_ scheme: WorkspaceScheme) throws {
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
