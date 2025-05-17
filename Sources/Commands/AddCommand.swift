import Foundation
import Get

/// Represents the parsed arguments for the add command
private struct AddCommandArguments {
    let eventId: String
}

enum AddCommandError: LocalizedError {
    case missingArguments
    case eventAlreadyExists(event: String)
    case eventValidationFailed(String)
    case eventNotFound(eventId: String)

    var errorDescription: String? {
        switch self {
        case .missingArguments:
            return """
                Usage: eventpanel add <event_name>
                Example: eventpanel add 'Button Tapped'
                """
        case .eventAlreadyExists(let event):
            return "Event '\(event)' already exists"
        case .eventValidationFailed(let message):
            return "Event validation failed: \(message)"
        case .eventNotFound(let eventId):
            return "Unable to find a specification for event `\(eventId)`"
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
    
    func execute(eventId: String) async throws {
        try await validateEvent(eventId: eventId)

        // Part 3: Add event to YAML file
        try await addEventToYaml(eventId: eventId)

        ConsoleLogger.success("Added event '\(eventId)'")
    }
    
    // MARK: - Private Methods
    
    /// Validates the event name with the server
    private func validateEvent(eventId: String) async throws {
        do {
            // Make a GET request to validate the event name
            try await networkClient.send(
                Request(path: "api/external/events/validate/\(eventId)", method: .get)
            )

            ConsoleLogger.debug("Event '\(eventId)' validation successful")
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
    private func addEventToYaml(eventId: String) async throws {
        try await eventPanelYaml.addEvent(eventId: eventId)
    }
}

// MARK: - Network Models

private struct EventValidationResponse: Decodable {
    let isValid: Bool
    let message: String?
} 
