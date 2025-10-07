import ArgumentParser

struct AddEvents: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "add-events",
        abstract: "Add events to EventPanel.yaml",
        discussion: """
        Adds all events or events from a specific category to your EventPanel.yaml configuration file.

        USAGE:
            eventpanel add-events --all
            eventpanel add-events --category <category-id>

        EXAMPLES:
            eventpanel add-events --all
            eventpanel add-events --category 'Login Screen'
            eventpanel add-events --category V1StGXR8
        """
    )

    @Flag(help: "Add all events from the configured source.")
    var all: Bool = false

    @Option(help: "Add events only from the specified category.")
    var categoryId: String?

    @Flag(
        name: [.customLong("scheme-update")],
        inversion: .prefixedNo,
        help: "Apply scheme update during generation."
    )
    var schemeUpdate: Bool = true

    func validate() throws {
        guard all || categoryId != nil else {
            throw ValidationError("You must specify either --all or --category <id>.")
        }
        if all && categoryId != nil {
            throw ValidationError("You cannot use --all and --category together.")
        }
    }

    func run() async throws {
        try await DependencyContainer.shared.addEventsCommand.execute(categoryId: categoryId)
        if schemeUpdate {
            try await DependencyContainer.shared.pullCommand.execute()
        }
    }
}
