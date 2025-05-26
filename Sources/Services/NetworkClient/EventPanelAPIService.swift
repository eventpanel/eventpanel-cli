import Foundation
import Get

final class EventPanelAPIService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

extension EventPanelAPIService {
    func getLatestEvent(
        eventId: String
    ) async throws -> LatestEventData {
        let response: Response<LatestEventData> = try await networkClient.send(
            Request(
                path: "api/external/events/latest/\(eventId)",
                method: .get
            )
        )
        return response.value
    }
}

struct EventLatestRequest: Encodable {
    let events: [LocalEventDefenitionData]
}

struct EventLatestResponse: Decodable {
    let events: [LatestEventData]
}

extension EventPanelAPIService {
    func getLatestEvents(
        events: EventLatestRequest
    ) async throws -> EventLatestResponse {
        let response: Response<EventLatestResponse> = try await networkClient.send(
            Request(
                path: "api/external/events/latest/list",
                method: .post,
                body: events
            )
        )
        return response.value
    }
}

struct SchemeRequest: Encodable {
    let events: [LocalEventDefenitionData]
}

extension EventPanelAPIService {
    func generateScheme(
        events: [LocalEventDefenitionData]
    ) async throws -> WorkspaceScheme {
        let response: Response<WorkspaceScheme> = try await networkClient.send(
            Request(
                path: "api/external/events/generate/list",
                method: .post,
                body: SchemeRequest(events: events)
            )
        )
        return response.value
    }
}
