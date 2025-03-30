import Foundation
import Get

enum OutdatedCommandError: LocalizedError {
    case eventCheckFailed(String)
    case targetNotFound(String)
    
    var errorDescription: String? {
        switch self {
        case .eventCheckFailed(let message):
            return "Failed to check event updates: \(message)"
        case .targetNotFound(let target):
            return "Target '\(target)' not found in configuration"
        }
    }
}

// MARK: - Models

private struct OutdatedEvent {
    let eventId: String
    let currentVersion: Int
    let latestVersion: Int
    
    var displayString: String {
        "- \(eventId) (`id`) \(currentVersion) -> latest version \(latestVersion)"
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
        
        let eventPanelYaml = try EventPanelYaml.read()
        let targets = eventPanelYaml.getTargets()
        
        let target = try parseTargetArgument(arguments, from: targets)
        let targetsToCheck = target.map { [$0] } ?? targets
        
        let outdatedEvents = try await checkEventsForUpdates(
            in: targetsToCheck,
            using: eventPanelYaml
        )
        
        displayResults(outdatedEvents)
    }
    
    // MARK: - Private Methods
    
    private func parseTargetArgument(_ arguments: [String], from targets: [String]) throws -> String? {
        if arguments.count >= 2, arguments[0] == "--target" {
            let target = arguments[1]
            guard targets.contains(target) else {
                throw OutdatedCommandError.targetNotFound(target)
            }
            return target
        }
        return nil
    }
    
    private func checkEventsForUpdates(
        in targets: [String],
        using eventPanelYaml: EventPanelYaml
    ) async throws -> [OutdatedEvent] {
        var outdatedEvents: [OutdatedEvent] = []
        var processedEvents = Set<String>()
        
        for target in targets {
            let events = try eventPanelYaml.getEvents(for: target)
            
            for event in events {
                guard !processedEvents.contains(event.name) else { continue }
                processedEvents.insert(event.name)
                
                if let outdatedEvent = try await checkEventForUpdates(event) {
                    outdatedEvents.append(outdatedEvent)
                }
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
