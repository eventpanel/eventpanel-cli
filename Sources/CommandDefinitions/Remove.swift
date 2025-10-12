import ArgumentParser

struct Remove: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "remove",
        abstract: "Remove an event from EventPanel.yaml",
        discussion: """
        Removes an event from your EventPanel.yaml configuration file.

        USAGE:
            eventpanel remove <event-id>

        ARGUMENTS:
            <event-id>      The unique identifier of the event to remove

        EXAMPLES:
            eventpanel remove DWnQMGoYrvUyaTGpbmvr9
        """
    )

    @Argument(help: "Event id to remove")
    var eventId: String

    @Flag(
        name: [.customLong("scheme-update")],
        inversion: .prefixedNo,
        help: "Apply scheme update during generation"
    )
    var schemeUpdate: Bool = true

    func run() async throws {
        try await DependencyContainer.shared.removeCommand.execute(eventId: eventId)

        if schemeUpdate {
            try await DependencyContainer.shared.pullCommand.execute()
        }
    }
}
