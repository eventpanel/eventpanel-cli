//
//  NetworkClient.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 12.03.2025.
//

import Get
import Foundation

typealias NetworkClient = APIClient

final class AuthAPIClientDelegate: APIClientDelegate {
    private var accessToken: String = ""

    init(accessToken: String) {
        self.accessToken = accessToken
    }

    func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws {
        request.setValue(accessToken, forHTTPHeaderField: "x-api-key")
    }

    func client(_ client: APIClient, validateResponse response: HTTPURLResponse, data: Data, task: URLSessionTask) throws {
        ConsoleLogger.debug(String(data: data, encoding: .utf8)!)
    }
}
