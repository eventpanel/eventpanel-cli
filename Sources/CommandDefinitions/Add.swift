import ArgumentParser

struct Add: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "add",
        abstract: "Add one or more events to EventPanel.yaml",
        discussion: """
        Adds events to your EventPanel.yaml configuration file.

        USAGE:
            eventpanel add <event-id> [--version <version>]
            eventpanel add --name <event-name>
            eventpanel add --all
            eventpanel add --category <category-id>
            eventpanel add --category-name <category-name>

        ARGUMENTS:
            <event-id>      The unique identifier of the event to add
            --name          The name of the event to add (fetches latest version)
            --version       (Optional) Specific version of the event to add (only with event-id)
            --all           Add all available events
            --category      Add all events from the specified category ID
            --category-name Add all events from the specified category name

        EXAMPLES:
            eventpanel add DWnQMGoYrvUyaTGpbmvr9
            eventpanel add DWnQMGoYrvUyaTGpbmvr9 --version 2
            eventpanel add --name "User Login"
            eventpanel add --all
            eventpanel add --category "abc123"
            eventpanel add --category-name "Login Screen"
        """
    )

    @Argument(help: "Event id (for adding a single event)", completion: .none)
    var eventId: String?

    @Option(
        name: [.customShort("n"), .long],
        help: "Event name (for adding a single event by name)"
    )
    var name: String?

    @Option(
        name: [.customShort("v"), .long],
        help: "Specific version of the event to add"
    )
    var version: Int?

    @Flag(help: "Add all events for the configured source")
    var all: Bool = false

    @Option(help: "Add all events from the specified category ID")
    var categoryId: String?

    @Option(
        name: [.customLong("category-name")],
        help: "Add all events from the specified category name"
    )
    var categoryName: String?

    @Flag(
        name: [.customLong("scheme-update")],
        inversion: .prefixedNo,
        help: "Apply scheme update during generation"
    )
    var schemeUpdate: Bool = true

    func validate() throws {
        // Ensure mutual exclusivity
        let modesUsed = [eventId != nil, name != nil, all, categoryId != nil, categoryName != nil].filter { $0 }
        guard modesUsed.count == 1 else {
            throw ValidationError("""
            You must specify exactly one of:
              - <event-id>
              - --name <event-name>
              - --all
              - --category <id>
              - --category-name <name>
            """)
        }
    }

    func run() async throws {
        if let eventId = eventId {
            try await DependencyContainer.shared.addCommand.execute(
                eventId: eventId,
                version: version
            )
        } else if let name = name {
            try await DependencyContainer.shared.addCommand.execute(eventName: name)
        } else if all {
            try await DependencyContainer.shared.addEventsCommand.execute(
                categoryId: nil,
                categoryName: nil
            )
        } else if let categoryId = categoryId {
            try await DependencyContainer.shared.addEventsCommand.execute(
                categoryId: categoryId,
                categoryName: nil
            )
        } else if let categoryName = categoryName {
            try await DependencyContainer.shared.addEventsCommand.execute(
                categoryId: nil,
                categoryName: categoryName
            )
        }

        if schemeUpdate {
            try await DependencyContainer.shared.pullCommand.execute()
        }
    }
}
