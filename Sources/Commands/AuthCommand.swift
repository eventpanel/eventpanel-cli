import Foundation
import Security

enum AuthCommandError: LocalizedError {
    case keychainError(String)
    case tokenNotFound
    
    var errorDescription: String? {
        switch self {
        case .keychainError(let message):
            return "Keychain error: \(message)"
        case .tokenNotFound:
            return "No API token found. Please set your API token using 'eventpanel auth set-token'"
        }
    }
}

final class AuthCommand {
    private let service = "com.eventpanel.cli"
    private let account = "api-token"
    
    func setToken(_ token: String) async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: token.data(using: .utf8)!
        ]
        
        // First try to delete any existing token
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw AuthCommandError.keychainError("Failed to save token: \(status)")
        }
        
        ConsoleLogger.success("API token has been saved successfully")
    }
    
    func getToken() throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            throw AuthCommandError.tokenNotFound
        }
        
        return token
    }
    
    func removeToken() async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AuthCommandError.keychainError("Failed to remove token: \(status)")
        }
        
        ConsoleLogger.success("API token has been removed successfully")
    }
} 