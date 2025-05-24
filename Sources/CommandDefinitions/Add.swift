import ArgumentParser

struct Add: AsyncParsableCommand, ConfigRelatedCommand {
    static let configuration = CommandConfiguration(
        commandName: "add",
        abstract: "Add event to EventPanel.yaml",
        discussion: """
        Adds a new event to your EventPanel.yaml configuration file.
        
        USAGE:
            eventpanel add <event-id> [<version>]
        
        ARGUMENTS:
            <event-id>    The unique identifier of the event to add
            <version>     (Optional) Specific version of the event to add
        
        EXAMPLES:
            eventpanel add DWnQMGoYrvUyaTGpbmvr9
        """
    )
    
    @Argument(help: "Event id")
    var eventId: String

    @Argument(help: "Event version")
    var version: Int?

    init() {}

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.addCommand.execute(eventId: eventId, version: version)
    }
} 