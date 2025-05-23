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
        abstract: "Add event to EventPanel.yaml",
        discussion: """
        Adds a new event to your EventPanel.yaml configuration file.
        
        USAGE:
            eventpanel add <event-id> [<version>]
        
        ARGUMENTS:
            <event-id>    The unique identifier of the event to add
            <version>     (Optional) Specific version of the event to add
        
        EXAMPLES:
            eventpanel add DWnQMGoYrvUyaTGpbmvr9
        """
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

    init() {}

    func run() async throws {
        try await DependencyContainer.shared.deintegrateCommand.execute()
    }
}

// MARK: - Generate Command
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
        abstract: "Show outdated events",
        discussion: """
        Checks for outdated events by comparing local versions with the latest available versions.
        
        USAGE:
            eventpanel outdated
        
        Display a list of events that have updates available
        """
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
        abstract: "Fetch and store the latest scheme from the server",
        discussion: """
        Fetches the latest event scheme from the server and updates your local configuration.
        
        USAGE:
            eventpanel pull
        
        This command will:
        - Connect to the EventPanel server
        - Download the latest event scheme
        """
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
        abstract: "Update events to their latest versions",
        discussion: """
        Updates the events identified by event id, which is a space-delimited list of event IDs.
        If no events are specified, it updates all outdated events.
        
        USAGE:
            eventpanel update [<event-id>...]
        
        ARGUMENTS:
            <event-id>...    Space-delimited list of event IDs to update. If not provided, updates all outdated events.
        
        EXAMPLES:
            eventpanel update
            
            eventpanel update DWnQMGoYrvUyaTGpbmvr9
            
            eventpanel update DWnQMGoYrvUyaTGpbmvr9 cKMpDL-DtggQFHxOoKLnq
        
        This command will:
        - Check for available updates for the specified events
        - Update the events to their latest versions
        - Update your EventPanel.yaml configuration
        """
    )

    @Argument(help: "Event ids to update (if not provided, updates all outdated events)")
    var eventIds: [String] = []

    init() {}

    func validate() throws {
        try validateConfig()
    }

    func run() async throws {
        try await DependencyContainer.shared.updateCommand.execute(eventIds: eventIds)
    }
}

// MARK: - Auth Command
struct Auth: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "auth",
        abstract: "Manage API authentication",
        discussion: """
        Manages authentication for the EventPanel API.
        
        USAGE:
            eventpanel auth <subcommand>
        
        SUBCOMMANDS:
            set-token     Set your API token
            remove-token  Remove stored API token
        
        Authentication is required for commands that interact with the EventPanel server.
        """
    )
}

// MARK: - Set Token Command
struct SetToken: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "set-token",
        abstract: "Set API token",
        discussion: """
        Stores your EventPanel API token for authentication.
        
        USAGE:
            eventpanel auth set-token <token>
        
        ARGUMENTS:
            <token>    Your EventPanel API token
        
        The token will be securely stored and used for all authenticated requests.
        """
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
        abstract: "Remove stored API token",
        discussion: """
        Removes your stored EventPanel API token.
        
        USAGE:
            eventpanel auth remove-token
        
        This will remove the stored API token and require re-authentication for future commands.
        """
    )
    
    init() {}
    
    func run() async throws {
        try await DependencyContainer.shared.authCommand.removeToken()
    }
}
