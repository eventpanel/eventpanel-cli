//
//  AuthTokenProvider.swift
//  eventpanel-cli
//
//  Created by Sukhanov Evgenii on 10.06.2025.
//

protocol AuthTokenProvider: Sendable {
    func getToken() async throws -> String
}

final class WorkspaceBasedAuthTokenProvider: AuthTokenProvider {
    private let authTokenService: AuthTokenService
    private let eventPanelYamlProvider: EventPanelYamlProvider

    init(
        authTokenService: AuthTokenService,
        eventPanelYamlProvider: EventPanelYamlProvider
    ) {
        self.authTokenService = authTokenService
        self.eventPanelYamlProvider = eventPanelYamlProvider
    }

    func getToken() async throws -> String {
        let eventPanelYaml = try await eventPanelYamlProvider.read()
        return try await authTokenService.getToken(workspaceId: eventPanelYaml.getWorkspaceId())
    }
}
