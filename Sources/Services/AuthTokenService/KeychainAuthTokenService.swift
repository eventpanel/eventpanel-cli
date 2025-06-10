//
//  KeychainAuthTokenService.swift
//  eventpanel-cli
//
//  Created by Sukhanov Evgenii on 10.06.2025.
//

import Foundation

final class KeychainAuthTokenService: AuthTokenService {
    private let service = "net.eventpanel.cli"
    
    private func accountIdentifier(for workspaceId: String?) -> String {
        if let workspaceId = workspaceId {
            return "api-token-\(workspaceId)"
        } else {
            return "api-token" // fallback for backward compatibility
        }
    }
    
    func setToken(_ token: String, workspaceId: String? = nil) async throws {
        let account = accountIdentifier(for: workspaceId)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: token.data(using: .utf8)!
        ]
        
        // First try to delete any existing token for this workspace
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw AuthError.keychainError("Failed to save token: \(status)")
        }
    }
    
    func getToken(workspaceId: String? = nil) throws -> String {
        let account = accountIdentifier(for: workspaceId)

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
            throw AuthError.tokenNotFound
        }
        
        return token
    }
    
    func removeToken(workspaceId: String? = nil) async throws {
        let account = accountIdentifier(for: workspaceId)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw AuthError.keychainError("Failed to remove token: \(status)")
        }
    }
}
