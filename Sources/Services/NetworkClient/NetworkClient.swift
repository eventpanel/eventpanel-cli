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
        ConsoleLogger.debug("Request URL: \(request.url?.absoluteString ?? "nil")")
        ConsoleLogger.debug("Request Method: \(request.httpMethod ?? "nil")")
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            ConsoleLogger.debug("Request Body: \(bodyString)")
        }
        
        let token = try authService.getToken()
        request.setValue(token, forHTTPHeaderField: "x-api-key")
    }

    func client(_ client: APIClient, validateResponse response: HTTPURLResponse, data: Data, task: URLSessionTask) throws {
        ConsoleLogger.debug("Response Body: \(String(data: data, encoding: .utf8)!)")

        guard (200..<300).contains(response.statusCode) else {
            if let backendApiError = try? JSONDecoder().decode(BackendAPIError.self, from: data) {
                throw backendApiError
            }
            throw APIError.unacceptableStatusCode(response.statusCode)
        }
    }
}
