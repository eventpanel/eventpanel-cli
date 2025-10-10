import Foundation
import Get

enum PullCommandError: LocalizedError {
    case fetchFailed(String)
    case invalidResponse
    case saveFailed(String)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return "Failed to fetch scheme: \(message)"
        case .invalidResponse:
            return "Invalid response from server"
        case .saveFailed(let message):
            return "Failed to save scheme: \(message)"
        }
    }
}

final class PullCommand {
    private let apiService: EventPanelAPIService
    private let configProvider: ConfigProvider
    private let configFileLocation: ConfigFileLocation
    private let fileManager: FileManager

    init(
        apiService: EventPanelAPIService,
        configProvider: ConfigProvider,
        configFileLocation: ConfigFileLocation,
        fileManager: FileManager
    ) {
        self.apiService = apiService
        self.configProvider = configProvider
        self.configFileLocation = configFileLocation
        self.fileManager = fileManager
    }

    func execute() async throws {
        ConsoleLogger.message("Fetching latest scheme...")

        let eventPanelYaml = try await configProvider.getEventPanelYaml()
        let events = await eventPanelYaml.getEvents()

        let scheme = try await fetchScheme(
            events: events,
            source: eventPanelYaml.getSource()
        )

        try saveScheme(scheme)

        ConsoleLogger.success("Successfully pulled and stored scheme")
    }

    private func fetchScheme(
        events: [Event],
        source: Source
    ) async throws -> WorkspaceScheme {
        do {
            let eventDefinitions = events.map {
                LocalEventDefenitionData(eventId: $0.id, version: $0.version ?? 1)
            }
            return try await apiService.generateScheme(
                events: eventDefinitions,
                source: source
            )
        } catch let error as APIError {
            throw PullCommandError.fetchFailed(error.localizedDescription)
        } catch {
            throw PullCommandError.fetchFailed(error.localizedDescription)
        }
    }

    private func saveScheme(_ scheme: WorkspaceScheme) throws {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        do {
            let data = try encoder.encode(scheme)

            let eventPanelDir = configFileLocation.cacheDirectory
            try fileManager.createDirectory(
                at: eventPanelDir,
                withIntermediateDirectories: true,
                attributes: nil
            )

            // Save scheme.json
            let schemeURL = eventPanelDir.appendingPathComponent("scheme.json")
            try data.write(to: schemeURL)

        } catch {
            throw PullCommandError.saveFailed(error.localizedDescription)
        }
    }
}
