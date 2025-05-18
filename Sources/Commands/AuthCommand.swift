import Foundation
import Security

final class AuthCommand {
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func setToken(_ token: String) async throws {
        try await authService.setToken(token)
        ConsoleLogger.success("API token has been saved successfully")
    }
    
    func getToken() throws -> String {
        let token = try authService.getToken()

        return token
    }
    
    func removeToken() async throws {
        try await authService.removeToken()
        ConsoleLogger.success("API token has been removed successfully")
    }
} 
