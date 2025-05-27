import ArgumentParser

struct Generate: AsyncParsableCommand, ConfigRelatedCommand {
    static let configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Generate events according to versions from a EventPanel.yaml",
        discussion: """
        Generates event code based on the versions specified in your EventPanel.yaml file.
        
        USAGE:
            eventpanel generate [--scheme-update]
        
        OPTIONS:
            --scheme-update    Updates the scheme before generating events
        
        This command will:
        - Read your EventPanel.yaml configuration
        - Generate event code for all configured events
        - Update your project's scheme if --scheme-update is specified
        """
    )

    @Flag(name: [.customLong("scheme-update")], help: "Apply scheme update during generation.")
    var schemeUpdate: Bool = false

    init() {}

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        if schemeUpdate {
            try await DependencyContainer.shared.pullCommand.execute()
        }
        try await DependencyContainer.shared.generateCommand.execute()
    }
} 
