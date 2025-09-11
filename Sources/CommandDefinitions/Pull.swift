import ArgumentParser

struct Pull: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "pull",
        abstract: "Fetch and store the latest scheme from the server",
        discussion: """
        Fetches the latest event scheme from the server and updates your local configuration.
        
        USAGE:
            eventpanel pull
        
        This command will:
        - Connect to the EventPanel server
        - Download the latest event scheme
        """
    )

    func run() async throws {
        try await DependencyContainer.shared.pullCommand.execute()
    }
} 
