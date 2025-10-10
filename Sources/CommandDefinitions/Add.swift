import ArgumentParser

struct Add: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "add",
        abstract: "Add one or more events to EventPanel.yaml",
        discussion: """
        Adds events to your EventPanel.yaml configuration file.

        USAGE:
            eventpanel add <event-id> [--version <version>]
            eventpanel add --all
            eventpanel add --category <category-id>

        ARGUMENTS:
            <event-id>      The unique identifier of the event to add
            --version       (Optional) Specific version of the event to add
            --all           Add all available events
            --category      Add all events from the specified category

        EXAMPLES:
            eventpanel add DWnQMGoYrvUyaTGpbmvr9
            eventpanel add DWnQMGoYrvUyaTGpbmvr9 --version 2
            eventpanel add --all
            eventpanel add --category "Login Screen"
        """
    )

    @Argument(help: "Event id (for adding a single event)", completion: .none)
    var eventId: String?

    @Option(
        name: [.customShort("v"), .long],
        help: "Specific version of the event to add"
    )
    var version: Int?

    @Flag(help: "Add all events for the configured source")
    var all: Bool = false

    @Option(help: "Add all events from the specified category")
    var categoryId: String?

    @Flag(
        name: [.customLong("scheme-update")],
        inversion: .prefixedNo,
        help: "Apply scheme update during generation"
    )
    var schemeUpdate: Bool = true

    func validate() throws {
        // Ensure mutual exclusivity
        let modesUsed = [eventId != nil, all, categoryId != nil].filter { $0 }
        guard modesUsed.count == 1 else {
            throw ValidationError("""
            You must specify exactly one of:
              - <event-id>
              - --all
              - --category <id>
            """)
        }
    }

    func run() async throws {
        if let eventId = eventId {
            try await DependencyContainer.shared.addCommand.execute(
                eventId: eventId,
                version: version
            )
        } else if all {
            try await DependencyContainer.shared.addEventsCommand.execute(categoryId: nil)
        } else if let categoryId = categoryId {
            try await DependencyContainer.shared.addEventsCommand.execute(categoryId: categoryId)
        }

        if schemeUpdate {
            try await DependencyContainer.shared.pullCommand.execute()
        }
    }
}
