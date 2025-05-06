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

final class AddCommand: Command {
    let name = "add"
    let description = "Add event to EventPanel.yaml"
    
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func execute(with arguments: [String]) async throws {
        // Part 1: Parse and validate arguments
        let parsedArgs = try parseArguments(arguments)
        
        // Part 2: Validate event with network request
        try await validateEvent(eventId: parsedArgs.eventId)

        // Part 3: Add event to YAML file
        try addEventToYaml(eventId: parsedArgs.eventId)

        ConsoleLogger.success("Added event '\(parsedArgs.eventId)'")
    }
    
    // MARK: - Private Methods
    
    /// Parses and validates command line arguments
    private func parseArguments(_ arguments: [String]) throws -> AddCommandArguments {
        guard !arguments.isEmpty else {
            throw AddCommandError.missingArguments
        }
        
        let eventId = arguments[0]

        let eventPanelYaml = try EventPanelYaml.read()

        return AddCommandArguments(eventId: eventId)
    }
    
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
    private func addEventToYaml(eventId: String) throws {
        let eventPanelYaml = try EventPanelYaml.read()
        try eventPanelYaml.addEvent(eventId: eventId)
    }
}

// MARK: - Network Models

private struct EventValidationResponse: Decodable {
    let isValid: Bool
    let message: String?
} 
