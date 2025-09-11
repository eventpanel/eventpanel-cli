import ArgumentParser

struct List: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "list",
        abstract: "List events",
        discussion: """
        Lists all events configured in your EventPanel.yaml file.
        
        USAGE:
            eventpanel list [--page-size <number>]
        
        OPTIONS:
            --page-size <number>    Number of items to display per page (default: 20)
        
        The list shows:
        - Event ID
        - Current version
        """
    )

    @Option(name: .long, help: "Number of items per page")
    var pageSize: Int = 20

    func run() async throws {
        try await DependencyContainer.shared.listCommand.execute(pageSize: pageSize)
    }
} 
