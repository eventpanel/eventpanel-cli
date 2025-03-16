import Foundation
import Get

enum OutdatedCommandError: LocalizedError {
    case eventCheckFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .eventCheckFailed(let message):
            return "Failed to check event updates: \(message)"
        }
    }
}

final class OutdatedCommand: Command {
    let name = "outdated"
    let description = "Show outdated events"
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func execute(with arguments: [String]) async throws {
        ConsoleLogger.message("Checking for outdated events...")
        
        // Read YAML file
        let eventPanelYaml = try EventPanelYaml.read()
        let targets = eventPanelYaml.getTargets()
        
        var outdatedEvents: [(eventId: String, currentVersion: String, latestVersion: String)] = []
        var processedEvents = Set<String>() // Keep track of processed events
        
        // Check each target's events
        for target in targets {
            let events = try eventPanelYaml.getEvents(for: target)
            
            for event in events {
                // Skip if we've already processed this event
                guard !processedEvents.contains(event.name) else { continue }
                processedEvents.insert(event.name)
                
                do {
                    // Check if event has a new version
                    let response: Response<EventLatestResponse> = try await networkClient.send(
                        Request(path: "api/external/events/latest/\(event.name)", method: .get)
                    )
                    
                    let currentVersion = event.version ?? "1"
                    if response.value.version != currentVersion {
                        outdatedEvents.append((
                            eventId: event.name,
                            currentVersion: currentVersion,
                            latestVersion: response.value.version
                        ))
                    }
                } catch let error as APIError {
                    throw OutdatedCommandError.eventCheckFailed(error.localizedDescription)
                } catch {
                    throw OutdatedCommandError.eventCheckFailed(error.localizedDescription)
                }
            }
        }
        
        if outdatedEvents.isEmpty {
            ConsoleLogger.message("All events are up to date")
            return
        }
        
        ConsoleLogger.message("The following event updates are available:")
        for event in outdatedEvents {
            ConsoleLogger.message("- \(event.eventId) \(event.currentVersion) -> latest version \(event.latestVersion)")
        }
    }
}

// MARK: - Network Models

private struct EventLatestResponse: Decodable {
    let version: String
} 
