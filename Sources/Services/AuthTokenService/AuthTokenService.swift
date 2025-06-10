import Foundation
import Security

protocol AuthTokenService: Sendable {
    func setToken(_ token: String, workspaceId: String?) async throws
    func getToken(workspaceId: String?) async throws -> String
    func removeToken(workspaceId: String?) async throws
}
