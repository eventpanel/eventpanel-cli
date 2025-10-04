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
    private let apiService: EventPanelAPIService
    private let configProvider: ConfigProvider

    init(apiService: EventPanelAPIService, configProvider: ConfigProvider) {
        self.apiService = apiService
        self.configProvider = configProvider
    }

    func execute(eventId: String, version: Int?) async throws {
        let eventPanelYaml = try await configProvider.getEventPanelYaml()
        let eventVersion = try await validateEvent(
            eventId: eventId,
            version: version,
            source: eventPanelYaml.getSource()
        )

        // Part 3: Add event to YAML file
        try await addEventToYaml(eventId: eventId, eventVersion: version ?? eventVersion, eventPanelYaml: eventPanelYaml)

        ConsoleLogger.success("Added event '\(eventId)'")
    }

    // MARK: - Private Methods

    /// Validates the event name with the server
    private func validateEvent(eventId: String, version: Int?, source: Source) async throws -> Int {
        if let version, version < 0 {
            throw AddCommandError.eventVersionIsNotValid(version: version)
        }
        do {
            let response = try await apiService.getLatestEvent(
                eventId: eventId,
                source: source
            )

            if let version, version > response.version {
                throw AddCommandError.eventVersionIsNotValid(version: version)
            }

            ConsoleLogger.debug("Event '\(eventId)' validation successful")
            return response.version
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
    private func addEventToYaml(eventId: String, eventVersion: Int, eventPanelYaml: EventPanelYaml) async throws {
        try await eventPanelYaml.addEvent(eventId: eventId, eventVersion: eventVersion)
    }
}

// MARK: - Network Models

private struct EventValidationResponse: Decodable {
    let isValid: Bool
    let message: String?
}
