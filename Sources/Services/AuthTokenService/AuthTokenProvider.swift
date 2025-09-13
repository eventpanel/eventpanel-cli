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
    private let configProvider: ConfigProvider

    init(
        authTokenService: AuthTokenService,
        configProvider: ConfigProvider
    ) {
        self.authTokenService = authTokenService
        self.configProvider = configProvider
    }

    func getToken() async throws -> String {
        let eventPanelYaml = try await configProvider.getEventPanelYaml()
        return try await authTokenService.getToken(workspaceId: eventPanelYaml.getWorkspaceId())
    }
}
