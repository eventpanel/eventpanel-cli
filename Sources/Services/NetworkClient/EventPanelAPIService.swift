import Foundation
import Get

final class EventPanelAPIService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    enum EventPanelError: LocalizedError {
        case invalidSource(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidSource(let message):
                return message
            }
        }
    }
}

struct LatestEventRequest: Encodable {
    let source: Source
}

extension EventPanelAPIService {
    func getLatestEvent(
        eventId: String,
        source: Source
    ) async throws -> LatestEventData {
        let response: Response<LatestEventData> = try await networkClient.send(
            Request(
                path: "backend-api/external/events/latest/\(eventId)",
                method: .get,
                query: [("source", source.rawValue)]
            )
        )
        return response.value
    }
}

struct LatestEventsRequest: Encodable {
    let events: [LocalEventDefenitionData]
    let source: Source
}

struct EventLatestResponse: Decodable {
    let events: [LatestEventData]
}

extension EventPanelAPIService {
    func getLatestEvents(
        events: [LocalEventDefenitionData],
        source: Source
    ) async throws -> EventLatestResponse {
        let response: Response<EventLatestResponse> = try await networkClient.send(
            Request(
                path: "backend-api/external/events/latest/list",
                method: .post,
                body: LatestEventsRequest(events: events, source: source)
            )
        )
        return response.value
    }
}

struct SchemeRequest: Encodable {
    let events: [LocalEventDefenitionData]
    let source: Source
}

extension EventPanelAPIService {
    func generateScheme(
        events: [LocalEventDefenitionData],
        source: Source
    ) async throws -> WorkspaceScheme {
        do {
            let response: Response<WorkspaceScheme> = try await networkClient.send(
                Request(
                    path: "backend-api/external/events/generate/list",
                    method: .post,
                    body: SchemeRequest(events: events, source: source)
                )
            )
            return response.value
        } catch let error as BackendAPIError {
            if error.error == "Unsupported Source" {
                throw EventPanelError.invalidSource(error.message)
            }
            throw error
        }
    }
}

struct WorkspaceResponse: Decodable {
    let workspaceId: String
}

extension EventPanelAPIService {
    func getWorkspace() async throws -> WorkspaceResponse {
        let response: Response<WorkspaceResponse> = try await networkClient.send(
            Request(
                path: "backend-api/external/workspace",
                method: .get
            )
        )
        return response.value
    }
}
