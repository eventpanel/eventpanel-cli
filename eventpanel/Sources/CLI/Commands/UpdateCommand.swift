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

final class UpdateCommand {
    private let networkClient: NetworkClient
    private let eventPanelYaml: EventPanelYaml

    init(networkClient: NetworkClient, eventPanelYaml: EventPanelYaml) {
        self.networkClient = networkClient
        self.eventPanelYaml = eventPanelYaml
    }
    
    func execute(eventId: String?) async throws {
        if let eventId {
            try await updateSingleEvent(eventId: eventId)
        } else {
            try await updateAllEvents()
        }
    }
    
    // MARK: - Private Methods
    
    private func updateSingleEvent(eventId: String) async throws {
        ConsoleLogger.message("Checking for updates to event '\(eventId)'...")

        let events = eventPanelYaml.getEvents()
        
        // Verify event exists in configuration
        guard let event = events.first(where: { $0.name == eventId }) else {
            throw UpdateCommandError.eventNotFound(eventId)
        }
        
        let currentVersion = event.version ?? 1
        
        do {
            // Check if event has a new version
            let requestBody = EventLatestRequest(events: [
                EventLatestRequestItem(
                    eventId: eventId,
                    version: currentVersion
                )
            ])
            
            let response: Response<EventLatestResponse> = try await networkClient.send(
                Request(
                    path: "api/external/events/latest",
                    method: .post,
                    body: requestBody
                )
            )
            
            if let updatedEvent = response.value.events.first(where: { $0.eventId == eventId }) {
                if updatedEvent.version != currentVersion {
                    // Update event version
                    try eventPanelYaml.updateEvent(
                        eventId: eventId,
                        version: updatedEvent.version
                    )
                    ConsoleLogger.success("Updated event '\(eventId)' to version \(updatedEvent.version)")
                } else {
                    ConsoleLogger.success("The event '\(eventId)' has latest version")
                }
            }
        } catch let error as APIError {
            throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
        } catch {
            throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
        }
    }
    
    private func updateAllEvents() async throws {
        ConsoleLogger.message("Checking for event updates...")
        
        // Read YAML file
        let events = eventPanelYaml.getEvents()
        
        guard !events.isEmpty else {
            throw UpdateCommandError.noEventsToUpdate
        }
        
        var updatedCount = 0
        
        // Check each event
        for event in events {
            do {
                let currentVersion = event.version ?? 1
                let requestBody = EventLatestRequest(events: [
                    EventLatestRequestItem(
                        eventId: event.name,
                        version: currentVersion
                    )
                ])
                
                // Check if event has a new version
                let response: Response<EventLatestResponse> = try await networkClient.send(
                    Request(
                        path: "api/external/events/latest",
                        method: .post,
                        body: requestBody
                    )
                )

                if let updatedEvent = response.value.events.first(where: { $0.eventId == event.name }),
                   updatedEvent.version != currentVersion {
                    // Update event version
                    try eventPanelYaml.updateEvent(
                        eventId: event.name,
                        version: updatedEvent.version
                    )
                    ConsoleLogger.success("Updated event '\(event.name)' to version \(updatedEvent.version)")
                    updatedCount += 1
                }
            } catch let error as APIError {
                throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
            } catch {
                throw UpdateCommandError.eventCheckFailed(error.localizedDescription)
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

private struct EventLatestRequest: Encodable {
    let events: [EventLatestRequestItem]
}

private struct EventLatestRequestItem: Codable {
    let eventId: String
    let version: Int
}

private struct EventLatestResponse: Decodable {
    let events: [EventLatestRequestItem]
} 
