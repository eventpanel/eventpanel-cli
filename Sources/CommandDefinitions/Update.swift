import ArgumentParser

struct Update: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "update",
        abstract: "Update events to their latest versions",
        discussion: """
        Updates the events identified by event id, which is a space-delimited list of event IDs.
        If no events are specified, it updates all outdated events.
        
        USAGE:
            eventpanel update [<event-id>...]
        
        ARGUMENTS:
            <event-id>...    Space-delimited list of event IDs to update. If not provided, updates all outdated events.
        
        EXAMPLES:
            eventpanel update
            
            eventpanel update DWnQMGoYrvUyaTGpbmvr9
            
            eventpanel update DWnQMGoYrvUyaTGpbmvr9 cKMpDL-DtggQFHxOoKLnq
        
        This command will:
        - Check for available updates for the specified events
        - Update the events to their latest versions
        - Update your EventPanel.yaml configuration
        """
    )

    @Argument(help: "Event ids to update (if not provided, updates all outdated events)")
    var eventIds: [String] = []

    @Flag(name: [.customLong("scheme-update")], help: "Apply scheme update during generation.")
    var schemeUpdate: Bool = true

    func run() async throws {
        try await DependencyContainer.shared.updateCommand.execute(eventIds: eventIds)
        if schemeUpdate {
            try await DependencyContainer.shared.pullCommand.execute()
        }
    }
} 
