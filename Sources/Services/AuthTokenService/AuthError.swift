//
//  AuthError.swift
//  eventpanel-cli
//
//  Created by Sukhanov Evgenii on 10.06.2025.
//

import Foundation

enum AuthError: LocalizedError {
    case keychainError(String)
    case tokenNotFound

    var errorDescription: String? {
        switch self {
        case .keychainError(let message):
            return "Keychain error: \(message)"
        case .tokenNotFound:
            return "No API token found. Please set your API token using 'eventpanel set-token'"
        }
    }
}
