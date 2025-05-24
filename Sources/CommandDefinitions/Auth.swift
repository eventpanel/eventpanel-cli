import ArgumentParser

struct Auth: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "auth",
        abstract: "Manage API authentication",
        discussion: """
        Manages authentication for the EventPanel API.
        
        USAGE:
            eventpanel auth <subcommand>
        
        SUBCOMMANDS:
            set-token     Set your API token
            remove-token  Remove stored API token
        
        Authentication is required for commands that interact with the EventPanel server.
        """
    )
}

struct SetToken: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "set-token",
        abstract: "Set API token",
        discussion: """
        Stores your EventPanel API token for authentication.
        
        USAGE:
            eventpanel auth set-token <token>
        
        ARGUMENTS:
            <token>    Your EventPanel API token
        
        The token will be securely stored and used for all authenticated requests.
        """
    )
    
    @Argument(help: "API token to store")
    var token: String
    
    init() {}
    
    func run() async throws {
        try await DependencyContainer.shared.authCommand.setToken(token)
    }
}

struct RemoveToken: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "remove-token",
        abstract: "Remove stored API token",
        discussion: """
        Removes your stored EventPanel API token.
        
        USAGE:
            eventpanel auth remove-token
        
        This will remove the stored API token and require re-authentication for future commands.
        """
    )
    
    init() {}
    
    func run() async throws {
        try await DependencyContainer.shared.authCommand.removeToken()
    }
} 