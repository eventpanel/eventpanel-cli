import Foundation
import Get

enum AddCommandError: LocalizedError {
    case eventAlreadyExists(event: String)
    case eventValidationFailed(String)
    case eventNotFound(eventId: String)
    case eventVersionIsNotValid(version: Int)

    var errorDescription: String? {
        switch self {
        case .eventAlreadyExists(let event):
            return "Event '\(event)' already exists"
        case .eventValidationFailed(let message):
            return "Event validation failed: \(message)"
        case .eventNotFound(let eventId):
            return "Unable to find a specification for event `\(eventId)`"
        case .eventVersionIsNotValid(let version):
            return "Event version is not valid: \(version)"
        }
    }
}

final class AddCommand {
    private let networkClient: NetworkClient
    private let eventPanelYaml: EventPanelYaml

    init(networkClient: NetworkClient, eventPanelYaml: EventPanelYaml) {
        self.networkClient = networkClient
        self.eventPanelYaml = eventPanelYaml
    }
    
    func execute(eventId: String, version: Int?) async throws {
        let eventVersion = try await validateEvent(eventId: eventId, version: version)

        // Part 3: Add event to YAML file
        try await addEventToYaml(eventId: eventId, eventVersion: version ?? eventVersion)

        ConsoleLogger.success("Added event '\(eventId)'")
    }
    
    // MARK: - Private Methods
    
    /// Validates the event name with the server
    private func validateEvent(eventId: String, version: Int?) async throws -> Int {
        if let version, version < 0 {
            throw AddCommandError.eventVersionIsNotValid(version: version)
        }
        do {
            // Make a GET request to validate the event name
            let response: Response<EventLatestRequestItem> = try await networkClient.send(
                Request(
                    path: "api/external/events/latest/\(eventId)",
                    method: .get
                )
            )

            if let version, version > response.value.version {
                throw AddCommandError.eventVersionIsNotValid(version: version)
            }

            ConsoleLogger.debug("Event '\(eventId)' validation successful")
            return response.value.version
        } catch let error as APIError {
            if case .unacceptableStatusCode(404) = error {
                throw AddCommandError.eventNotFound(eventId: eventId)
            }
            throw AddCommandError.eventValidationFailed(error.localizedDescription)
        } catch {
            throw AddCommandError.eventValidationFailed(error.localizedDescription)
        }
    }
    
    /// Adds the validated event to the YAML configuration
    private func addEventToYaml(eventId: String, eventVersion: Int) async throws {
        try await eventPanelYaml.addEvent(eventId: eventId, eventVersion: eventVersion)
    }
}

// MARK: - Network Models

private struct EventValidationResponse: Decodable {
    let isValid: Bool
    let message: String?
} 
