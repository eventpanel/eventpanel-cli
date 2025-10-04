import ArgumentParser

struct Init: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Initializes EventPanel in the project by creating the necessary configuration files"
    )

    @Option(name: .long, help: "Output path for generated events file (e.g., 'DemoApp/Analytics/GeneratedAnalyticsEvents.swift')")
    var output: String

    func run() async throws {
        try await DependencyContainer.shared.initCommand.execute(outputPath: output)
    }
}
