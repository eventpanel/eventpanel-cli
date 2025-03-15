import Foundation
import Get

enum UpdateCommandError: LocalizedError {
    case eventCheckFailed(String)
    case noEventsToUpdate
    case eventNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .eventCheckFailed(let message):
            return "Failed to check event updates: \(message)"
        case .noEventsToUpdate:
            return "No events to update"
        case .eventNotFound(let eventId):
            return "Unable to find a specification for '\(eventId)'"
        }
    }
}

final class UpdateCommand: Command {
    let name = "update"
    let description = "Update outdated events"
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func execute(with arguments: [String]) async throws {
        if arguments.isEmpty {
            try await updateAllEvents()
        } else {
            try await updateSingleEvent(eventId: arguments[0])
        }
    }
    
    // MARK: - Private Methods
    
    private func updateSingleEvent(eventId: String) async throws {
        ConsoleLogger.message("Checking for updates to event '\(eventId)'...")
        
        let eventPanelYaml = try EventPanelYaml.read()
        
        // Verify event exists in configuration
        var eventFound = false
        for target in eventPanelYaml.getTargets() {
            let events = try eventPanelYaml.getEvents(for: target)
            if events.contains(where: { $0.name == eventId }) {
                eventFound = true
                break
            }
        }
        
        guard eventFound else {
            throw UpdateCommandError.eventNotFound(eventId)
        }
        
        do {
            // Check if event has a new version
            let response: Response<EventLatestResponse> = try await networkClient.send(
                Request(path: "api/external/event/latest/\(eventId)", method: .get)
            )
            
            // Update event version
            try eventPanelYaml.updateEvent(
                eventId: eventId,
                version: response.value.version
            )
            ConsoleLogger.success("Updated event '\(eventId)' to version \(response.value.version)")
        } catch let error as APIError {
            throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
        } catch {
            throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
        }
    }
    
    private func updateAllEvents() async throws {
        ConsoleLogger.message("Checking for event updates...")
        
        // Read YAML file
        let eventPanelYaml = try EventPanelYaml.read()
        let targets = eventPanelYaml.getTargets()
        
        var updatedCount = 0
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
                        Request(path: "api/external/event/latest/\(event.name)", method: .get)
                    )

                    let currentVersion = event.version ?? "1"
                    if response.value.version != currentVersion {
                        // Update event version
                        try eventPanelYaml.updateEvent(
                            eventId: event.name,
                            version: response.value.version
                        )
                        ConsoleLogger.success("Updated event '\(event.name)' to version \(response.value.version)")
                        updatedCount += 1
                    }
                } catch let error as APIError {
                    throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
                } catch {
                    throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
                }
            }
        }
        
        if updatedCount == 0 {
            ConsoleLogger.message("All events are up to date")
        } else {
            ConsoleLogger.success("Updated \(updatedCount) event(s)")
        }
    }
}

// MARK: - Network Models

private struct EventLatestResponse: Decodable {
    let version: String
} 
