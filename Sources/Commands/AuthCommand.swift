import Foundation
import Security

final class AuthCommand {
    private let apiService: EventPanelAPIService
    private let authTokenService: AuthTokenService
    private let eventPanelYaml: EventPanelYaml

    init(
        apiService: EventPanelAPIService,
        authTokenService: AuthTokenService,
        eventPanelYaml: EventPanelYaml
    ) {
        self.apiService = apiService
        self.authTokenService = authTokenService
        self.eventPanelYaml = eventPanelYaml
    }
    
    func setToken(_ token: String) async throws {
        let id = try await fetchWorkspaceId(token: token)

        try await authTokenService.setToken(token, workspaceId: id)
        ConsoleLogger.success("API token has been saved successfully")
    }
    
    func removeToken() async throws {
        let workspaceId = await eventPanelYaml.getWorkspaceId()
        try await authTokenService.removeToken(workspaceId: workspaceId)
        ConsoleLogger.success("API token has been removed successfully")
    }

    private func fetchWorkspaceId(token: String) async throws -> String? {
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
