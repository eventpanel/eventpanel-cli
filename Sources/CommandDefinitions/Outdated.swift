import ArgumentParser

struct Outdated: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "outdated",
        abstract: "Show outdated events",
        discussion: """
        Checks for outdated events by comparing local versions with the latest available versions.
        
        USAGE:
            eventpanel outdated
        
        Display a list of events that have updates available
        """
    )

    func run() async throws {
        try await DependencyContainer.shared.outdatedCommand.execute()
    }
} 
