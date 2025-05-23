//
//  Add.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 06.05.2025.
//

import ArgumentParser

// MARK: - Add Command
struct Add: AsyncParsableCommand, ConfigRelatedCommand {
    static let configuration = CommandConfiguration(
        commandName: "add",
        abstract: "Add event to EventPanel.yaml"
    )
    
    @Argument(help: "Event id")
    var eventId: String

    @Argument(help: "Event version")
    var version: Int?

    init() {}

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.addCommand.execute(eventId: eventId, version: version)
    }
}

// MARK: - Deintegrate Command
struct Deintegrate: AsyncParsableCommand, ConfigRelatedCommand {
    static let configuration = CommandConfiguration(
        commandName: "deintegrate",
        abstract: "Deintegrate EventPanel from your project"
    )

    init() {}

    func run() async throws {
        try await DependencyContainer.shared.deintegrateCommand.execute()
    }
}

// MARK: - Generate Command
struct Generate: AsyncParsableCommand, ConfigRelatedCommand {
    static let configuration = CommandConfiguration(
        commandName: "generate",
        abstract: "Generate events according to versions from a EventPanel.yaml"
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

// MARK: - Help Command
struct Help: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "help",
        abstract: "Show this help message"
    )

    init() {}

    func run() async throws {
        ConsoleLogger.message(EventPanel.helpMessage())
    }
}

// MARK: - Init Command
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

// MARK: - List Command
struct List: AsyncParsableCommand, ConfigRelatedCommand {
    static let configuration = CommandConfiguration(
        commandName: "list",
        abstract: "List events"
    )

    @Option(name: .long, help: "Number of items per page")
    var pageSize: Int = 20

    init() {}

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.listCommand.execute(pageSize: pageSize)
    }
}

// MARK: - Outdated Command
struct Outdated: AsyncParsableCommand, ConfigRelatedCommand {
    static let configuration = CommandConfiguration(
        commandName: "outdated",
        abstract: "Show outdated events"
    )

    init() {}

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.outdatedCommand.execute()
    }
}

// MARK: - Pull Command
struct Pull: AsyncParsableCommand, ConfigRelatedCommand {
    static let configuration = CommandConfiguration(
        commandName: "pull",
        abstract: "Fetch and store the latest scheme from the server"
    )

    init() {}

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.pullCommand.execute()
    }
}

// MARK: - Update Command
struct Update: AsyncParsableCommand, ConfigRelatedCommand {
    static let configuration = CommandConfiguration(
        commandName: "update",
        abstract: "Update outdated events"
    )

    @Argument(help: "Event name to update (optional)")
    var eventName: String?

    init() {}

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.updateCommand.execute(eventId: eventName)
    }
}

// MARK: - Auth Command
struct Auth: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "auth",
        abstract: "Manage API authentication",
        subcommands: [
            SetToken.self,
            RemoveToken.self
        ]
    )
}

// MARK: - Set Token Command
struct SetToken: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "set-token",
        abstract: "Set API token"
    )
    
    @Argument(help: "API token to store")
    var token: String
    
    init() {}
    
    func run() async throws {
        try await DependencyContainer.shared.authCommand.setToken(token)
    }
}

// MARK: - Remove Token Command
struct RemoveToken: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "remove-token",
        abstract: "Remove stored API token"
    )
    
    init() {}
    
    func run() async throws {
        try await DependencyContainer.shared.authCommand.removeToken()
    }
}
