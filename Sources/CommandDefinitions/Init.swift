import ArgumentParser

struct Init: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Initializes EventPanel in the project by creating the necessary configuration files"
    )

    init() {}

    func run() async throws {
        try await DependencyContainer.shared.initCommand.execute()
    }
} 