import Foundation
import Security

final class AuthCommand {
    private let apiService: EventPanelAPIService
    private let authTokenService: AuthTokenService
    private let configProvider: ConfigProvider

    init(
        apiService: EventPanelAPIService,
        authTokenService: AuthTokenService,
        configProvider: ConfigProvider
    ) {
        self.apiService = apiService
        self.authTokenService = authTokenService
        self.configProvider = configProvider
    }

    func setToken(_ token: String) async throws {
        let id = try await fetchWorkspaceId(token: token)

        try await authTokenService.setToken(token, workspaceId: id)
        ConsoleLogger.success("API token has been saved successfully")
    }

    func removeToken() async throws {
        let eventPanelYaml = try await configProvider.getEventPanelYaml()
        let workspaceId = await eventPanelYaml.getWorkspaceId()
        try await authTokenService.removeToken(workspaceId: workspaceId)
        ConsoleLogger.success("API token has been removed successfully")
    }

    private func fetchWorkspaceId(token: String) async throws -> String? {
        let eventPanelYaml = try await configProvider.getEventPanelYaml()
        let currentWorkspaceId = await eventPanelYaml.getWorkspaceId()

        if currentWorkspaceId != nil {
            try await eventPanelYaml.setWorkspaceId(nil)
        }

        do {
            try await authTokenService.setToken(token, workspaceId: nil)
            let workspace = try await apiService.getWorkspace()
            try await authTokenService.removeToken(workspaceId: nil)
            try await eventPanelYaml.setWorkspaceId(workspace.workspaceId)
            return workspace.workspaceId
        } catch {
            if currentWorkspaceId != nil {
                try await eventPanelYaml.setWorkspaceId(currentWorkspaceId)
            }
            throw error
        }
    }
}
