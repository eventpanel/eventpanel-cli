import Foundation
import Get

enum AddCommandError: LocalizedError {
    case eventAlreadyExists(event: String)
    case eventValidationFailed(String)
    case eventNotFound(eventId: String)
    case eventNotFoundByName(name: String)
    case eventVersionIsNotValid(version: Int)

    var errorDescription: String? {
        switch self {
        case .eventAlreadyExists(let event):
            return "Event '\(event)' already exists"
        case .eventValidationFailed(let message):
            return "Event validation failed: \(message)"
        case .eventNotFound(let eventId):
            return "Unable to find a specification for event `\(eventId)`"
        case .eventNotFoundByName(let name):
            return "Unable to find a specification for event with name `\(name)`"
        case .eventVersionIsNotValid(let version):
            return "Event version is not valid: \(version)"
        }
    }
}

final class AddCommand {
    private let apiService: EventPanelAPIService
    private let configProvider: ConfigProvider

    init(apiService: EventPanelAPIService, configProvider: ConfigProvider) {
        self.apiService = apiService
        self.configProvider = configProvider
    }

    func execute(eventId: String, version: Int?) async throws {
        let eventPanelYaml = try await configProvider.getEventPanelYaml()
        let event = try await validateEvent(
            eventId: eventId,
            version: version,
            source: eventPanelYaml.getSource()
        )

        try await addEventToYaml(
            eventId: eventId,
            eventVersion: version ?? event.version,
            eventPanelYaml: eventPanelYaml
        )

        ConsoleLogger.success("Added event '\(eventId)'")
    }

    func execute(eventName: String) async throws {
        let eventPanelYaml = try await configProvider.getEventPanelYaml()
        let event = try await validateEventByName(
            eventName: eventName,
            source: eventPanelYaml.getSource()
        )

        try await addEventToYaml(
            eventId: event.eventId,
            eventVersion: event.version,
            eventPanelYaml: eventPanelYaml
        )

        ConsoleLogger.success("Added event '\(event.eventId)' (name: '\(eventName)')")
    }

    // MARK: - Private Methods

    /// Validates the event name with the server
    private func validateEvent(eventId: String, version: Int?, source: Source) async throws -> LatestEventData {
        if let version, version < 0 {
            throw AddCommandError.eventVersionIsNotValid(version: version)
        }
        do {
            let event = try await apiService.getLatestEvent(
                eventId: eventId,
                source: source
            )

            if let version, version > event.version {
                throw AddCommandError.eventVersionIsNotValid(version: version)
            }

            ConsoleLogger.debug("Event '\(eventId)' validation successful")
            return event
        } catch let error as APIError {
            if case .unacceptableStatusCode(404) = error {
                throw AddCommandError.eventNotFound(eventId: eventId)
            }
            throw AddCommandError.eventValidationFailed(error.localizedDescription)
        } catch {
            throw AddCommandError.eventValidationFailed(error.localizedDescription)
        }
    }

    /// Validates the event by name with the server
    private func validateEventByName(eventName: String, source: Source) async throws -> LatestEventData {
        do {
            let event = try await apiService.getLatestEventByName(
                name: eventName,
                source: source
            )

            ConsoleLogger.debug("Event '\(eventName)' validation successful")
            return event
        } catch let error as APIError {
            if case .unacceptableStatusCode(404) = error {
                throw AddCommandError.eventNotFoundByName(name: eventName)
            }
            throw AddCommandError.eventValidationFailed(error.localizedDescription)
        } catch {
            throw AddCommandError.eventValidationFailed(error.localizedDescription)
        }
    }

    /// Adds the validated event to the YAML configuration
    private func addEventToYaml(eventId: String, eventVersion: Int, eventPanelYaml: EventPanelYaml) async throws {
        try await eventPanelYaml.addEvent(Event(id: eventId, version: eventVersion))
    }
}

// MARK: - Network Models

private struct EventValidationResponse: Decodable {
    let isValid: Bool
    let message: String?
}
