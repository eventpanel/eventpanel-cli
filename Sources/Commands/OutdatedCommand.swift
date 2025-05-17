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

// MARK: - Models

private struct OutdatedEvent {
    let eventId: String
    let currentVersion: Int
    let latestVersion: Int
    
    var displayString: String {
        "- \(eventId) \(currentVersion) -> latest version \(latestVersion)"
    }
}

final class OutdatedCommand {
    private let networkClient: NetworkClient
    private let eventPanelYaml: EventPanelYaml

    init(networkClient: NetworkClient, eventPanelYaml: EventPanelYaml) {
        self.networkClient = networkClient
        self.eventPanelYaml = eventPanelYaml
    }
    
    func execute() async throws {
        ConsoleLogger.message("Checking for outdated events...")

        let events = await eventPanelYaml.getEvents()
        
        let outdatedEvents = try await checkEventsForUpdates(events)
        displayResults(outdatedEvents)
    }
    
    // MARK: - Private Methods
    
    private func checkEventsForUpdates(_ events: [Event]) async throws -> [OutdatedEvent] {
        var outdatedEvents: [OutdatedEvent] = []
        
        for event in events {
            if let outdatedEvent = try await checkEventForUpdates(event) {
                outdatedEvents.append(outdatedEvent)
            }
        }
        
        return outdatedEvents
    }
    
    private func checkEventForUpdates(_ event: Event) async throws -> OutdatedEvent? {
        do {
            let requestBody = EventLatestRequest(events: [
                EventLatestRequestItem(
                    eventId: event.name,
                    version: event.version ?? 1
                )
            ])
            
            let response: Response<EventLatestResponse> = try await networkClient.send(
                Request(
                    path: "api/external/events/latest",
                    method: .post,
                    body: requestBody
                )
            )
            
            let currentVersion = event.version ?? 1
            if let updatedEvent = response.value.events.first(where: { $0.eventId == event.name }),
               updatedEvent.version != currentVersion {
                return OutdatedEvent(
                    eventId: event.name,
                    currentVersion: currentVersion,
                    latestVersion: updatedEvent.version
                )
            }
        } catch let error as APIError {
            throw OutdatedCommandError.eventCheckFailed(error.localizedDescription)
        } catch {
            throw OutdatedCommandError.eventCheckFailed(error.localizedDescription)
        }
        
        return nil
    }
    
    private func displayResults(_ outdatedEvents: [OutdatedEvent]) {
        if outdatedEvents.isEmpty {
            ConsoleLogger.message("All events are up to date")
            return
        }
        
        ConsoleLogger.message("The following event updates are available:")
        for event in outdatedEvents {
            ConsoleLogger.message(event.displayString)
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
