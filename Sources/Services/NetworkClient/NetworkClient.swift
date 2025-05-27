import Get
import Foundation

typealias NetworkClient = APIClient

// handle {"message":"error.accessTokenNotFound","error":"Not Found","statusCode":404}
final class AuthAPIClientDelegate: APIClientDelegate, Sendable {
    private let authService: AuthService

    init(authService: AuthService) {
        self.authService = authService
    }

    func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws {
        let token = try authService.getToken()
        request.setValue(token, forHTTPHeaderField: "x-api-key")
    }

    func client(_ client: APIClient, validateResponse response: HTTPURLResponse, data: Data, task: URLSessionTask) throws {
        ConsoleLogger.debug(String(data: data, encoding: .utf8)!)
    }
}
