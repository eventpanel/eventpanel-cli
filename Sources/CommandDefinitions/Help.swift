import ArgumentParser

struct Help: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "help",
        abstract: "Show this help message"
    )

    func run() async throws {
        ConsoleLogger.message(EventPanel.helpMessage())
    }
}
