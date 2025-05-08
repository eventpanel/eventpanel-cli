//
//  Add.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 06.05.2025.
//

import ArgumentParser

// MARK: - Add Command
struct Add: AsyncParsableCommand, ConfigRelatedCommand {
    static var configuration = CommandConfiguration(
        commandName: "add",
        abstract: "Add event to EventPanel.yaml"
    )

    @Argument(help: "Event name to add")
    var eventName: String

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.addCommand.execute(eventId: eventName)
    }
}

// MARK: - Deintegrate Command
struct Deintegrate: AsyncParsableCommand, ConfigRelatedCommand {
    static var configuration = CommandConfiguration(
        commandName: "deintegrate",
        abstract: "Deintegrate EventPanel from your project"
    )

    func run() async throws {
        try await DependencyContainer.shared.deintegrateCommand.execute()
    }
}

// MARK: - Generate Command
struct Generate: AsyncParsableCommand, ConfigRelatedCommand {
    static var configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Generate events according to versions from a EventPanel.yaml"
    )

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.generateCommand.execute()
    }
}

// MARK: - Help Command
struct Help: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "help",
        abstract: "Show this help message"
    )

    func run() async throws {
        print(EventPanel.helpMessage())
    }
}

// MARK: - Init Command
struct Init: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "init",
        abstract: "Initializes EventPanel in the project by creating the necessary configuration files"
    )

    func run() async throws {
        try await DependencyContainer.shared.initCommand.execute()
    }
}

// MARK: - List Command
struct List: AsyncParsableCommand, ConfigRelatedCommand {
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "List events"
    )

    @Option(name: .long, help: "Number of items per page")
    var pageSize: Int = 20

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.listCommand.execute(pageSize: pageSize)
    }
}

// MARK: - Outdated Command
struct Outdated: AsyncParsableCommand, ConfigRelatedCommand {
    static var configuration = CommandConfiguration(
        commandName: "outdated",
        abstract: "Show outdated events"
    )

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.outdatedCommand.execute()
    }
}

// MARK: - Pull Command
struct Pull: AsyncParsableCommand, ConfigRelatedCommand {
    static var configuration = CommandConfiguration(
        commandName: "pull",
        abstract: "Fetch and store the latest scheme from the server"
    )

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.pullCommand.execute()
    }
}

// MARK: - Update Command
struct Update: AsyncParsableCommand, ConfigRelatedCommand {
    static var configuration = CommandConfiguration(
        commandName: "update",
        abstract: "Update outdated events"
    )

    @Argument(help: "Event name to update (optional)")
    var eventName: String?

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.updateCommand.execute(eventId: eventName)
    }
}
