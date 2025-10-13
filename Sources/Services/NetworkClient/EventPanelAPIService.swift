import Foundation
import Get

final class EventPanelAPIService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    enum EventPanelError: LocalizedError {
        case invalidSource(String)
        case categoryNotFound(String)

        var errorDescription: String? {
            switch self {
            case .invalidSource(let message):
                return message
            case .categoryNotFound(let categoryId):
                return "Category '\(categoryId)' not found or archived"
            }
        }
    }
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
    
    func getLatestEventByName(
        name: String,
        source: Source
    ) async throws -> LatestEventData {
        do {
            let response: Response<LatestEventData> = try await networkClient.send(
                Request(
                    path: "backend-api/external/events/latest",
                    method: .get,
                    query: [
                        ("name", name),
                        ("source", source.rawValue)
                    ]
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

struct LatestEventsRequest: Encodable {
    let events: [LocalEventDefenitionData]
    let source: Source
}

extension EventPanelAPIService {
    func getLatestEvents(
        events: [LocalEventDefenitionData],
        source: Source
    ) async throws -> [LatestEventData] {
        let response: Response<[LatestEventData]> = try await networkClient.send(
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

extension EventPanelAPIService {
    func getEvents(
        categoryId: String,
        source: Source?
    ) async throws -> [LatestEventData] {
        var queryItems: [(String, String)] = []
        if let source = source {
            queryItems.append(("source", source.rawValue))
        }

        do {
            let response: Response<[LatestEventData]> = try await networkClient.send(
                Request(
                    path: "backend-api/external/events/category/\(categoryId)",
                    method: .get,
                    query: queryItems
                )
            )
            return response.value
        } catch let error as BackendAPIError {
            if error.status == 404 {
                throw EventPanelError.categoryNotFound(categoryId)
            }
            throw error
        }
    }

    func getEventsByCategoryName(
        categoryName: String,
        source: Source?
    ) async throws -> [LatestEventData] {
        var queryItems: [(String, String)] = [("categoryName", categoryName)]
        if let source = source {
            queryItems.append(("source", source.rawValue))
        }

        do {
            let response: Response<[LatestEventData]> = try await networkClient.send(
                Request(
                    path: "backend-api/external/events/category",
                    method: .get,
                    query: queryItems
                )
            )
            return response.value
        } catch let error as BackendAPIError {
            if error.status == 404 {
                throw EventPanelError.categoryNotFound(categoryName)
            }
            throw error
        }
    }

    func getEvents(
        source: String
    ) async throws -> [LatestEventData] {
        let response: Response<[LatestEventData]> = try await networkClient.send(
            Request(
                path: "backend-api/external/events/source/\(source)",
                method: .get
            )
        )
        return response.value
    }
}
