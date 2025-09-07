import Foundation

final class DependencyContainer: @unchecked Sendable {
    // MARK: - Shared Instance
    static let shared = DependencyContainer()
    
    // MARK: - Dependencies
    private let authTokenService: AuthTokenService = {
        KeychainAuthTokenService()
    }()

    private(set) lazy var generatorPluginFactory: GeneratorPluginFactory = {
        DefaultGeneratorPluginFactory(fileManager: fileManager)
    }()

    private(set) lazy var authCommand: AuthCommand = {
        AuthCommand(
            apiService: apiService,
            authTokenService: authTokenService,
            eventPanelYaml: eventPanelYaml
        )
    }()
    
    private lazy var networkClient: NetworkClient = {
        let authAPIClientDelegate = AuthAPIClientDelegate(authTokenProvider: authTokenProvider)
        let networkClient = NetworkClient(baseURL: Environment.current.baseURL) {
            $0.delegate = authAPIClientDelegate
        }
        return networkClient
    }()
    
    private lazy var apiService: EventPanelAPIService = {
        return EventPanelAPIService(networkClient: networkClient)
    }()

    private lazy var authTokenProvider: AuthTokenProvider = {
        return WorkspaceBasedAuthTokenProvider(
            authTokenService: authTokenService,
            eventPanelYamlProvider: FileEventPanelYamlProvider()
        )
    }()

    private(set) lazy var fileManager: FileManager = {
        return .default
    }()

    private(set) lazy var eventPanelYaml: EventPanelYaml = {
        try! EventPanelYaml.read(fileManager: fileManager)
    }()

    // MARK: - Commands
    private(set) lazy var addCommand: AddCommand = {
        return AddCommand(apiService: apiService, eventPanelYaml: eventPanelYaml)
    }()
    
    private(set) lazy var deintegrateCommand: DeintegrateCommand = {
        return DeintegrateCommand(fileManager: fileManager)
    }()
    
    private(set) lazy var generateCommand: GenerateCommand = {
        return GenerateCommand(
            eventPanelYaml: eventPanelYaml,
            generatorPluginFactory: generatorPluginFactory
        )
    }()
    
    private(set) lazy var initCommand: InitCommand = {
        return InitCommand(generatorPluginFactory: generatorPluginFactory, fileManager: fileManager)
    }()
    
    private(set) lazy var listCommand: ListCommand = {
        return ListCommand(networkClient: networkClient, eventPanelYaml: eventPanelYaml)
    }()
    
    private(set) lazy var outdatedCommand: OutdatedCommand = {
        return OutdatedCommand(apiService: apiService, eventPanelYaml: eventPanelYaml)
    }()
    
    private(set) lazy var pullCommand: PullCommand = {
        return PullCommand(apiService: apiService, eventPanelYaml: eventPanelYaml, fileManager: fileManager)
    }()
    
    private(set) lazy var updateCommand: UpdateCommand = {
        return UpdateCommand(apiService: apiService, eventPanelYaml: eventPanelYaml)
    }()
    
    // MARK: - Private Initializer
    private init() {}
} 
