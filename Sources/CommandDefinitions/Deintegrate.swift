import ArgumentParser

struct Deintegrate: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "deintegrate",
        abstract: "Deintegrate EventPanel from your project",
        discussion: """
        Removes EventPanel integration from your project by cleaning up all configuration files
        and generated code.

        USAGE:
            eventpanel deintegrate

        This command will:
        - Remove EventPanel.yaml configuration
        - Clean up generated event files
        - Remove any EventPanel-related build settings
        """
    )

    func run() async throws {
        try await DependencyContainer.shared.deintegrateCommand.execute()
    }
}
