import ArgumentParser

struct Init: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Initializes EventPanel in the project by creating the necessary configuration files"
    )

    @Option(name: .long, help: "Output path for generated events file (e.g., 'DemoApp/Analytics/GeneratedAnalyticsEvents.swift')")
    var output: String

    @Option(name: .long, help: "Platform source type (android, iOS, web). If not specified, will auto-detect from project structure.")
    var source: String?

    func validate() throws {
        if let source = source {
            guard Source(rawValue: source) != nil else {
                throw ValidationError("Invalid source: \(source)")
            }
        }
    }

    func run() async throws {
        try await DependencyContainer.shared.initCommand.execute(
            outputPath: output,
            source: source.flatMap { Source(rawValue: $0) }
        )
    }
}
