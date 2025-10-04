import ArgumentParser

struct Add: AsyncParsableCommand {
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
            eventpanel add DWnQMGoYrvUyaTGpbmvr9 --version 2
        """
    )

    @Argument(help: "Event id")
    var eventId: String

    @Option(
        name: [.customShort("v"), .long],
        help: "Specific version of the event to add."
    )
    var version: Int?

    @Flag(name: [.customLong("scheme-update")], help: "Apply scheme update during generation.")
    var schemeUpdate: Bool = true

    func run() async throws {
        try await DependencyContainer.shared.addCommand.execute(eventId: eventId, version: version)
        if schemeUpdate {
            try await DependencyContainer.shared.pullCommand.execute()
        }
    }
}
