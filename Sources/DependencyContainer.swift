import Foundation

final class DependencyContainer: @unchecked Sendable {
    // MARK: - Shared Instance
    static let shared = DependencyContainer()

    var configFileLocation: ConfigFileLocation {
        ConfigFileLocationProvider.configFileLocation
    }

    // MARK: - Dependencies
    private let authTokenService: AuthTokenService = {
        KeychainAuthTokenService()
    }()

    private(set) lazy var generatorPluginFactory: GeneratorPluginFactory = {
        DefaultGeneratorPluginFactory(
            configFileLocation: configFileLocation,
            fileManager: fileManager
        )
    }()

    private(set) lazy var configProvider: ConfigProvider = {
        FileConfigProvider(
            configFileLocation: configFileLocation,
            fileManager: fileManager
        )
    }()

    private(set) lazy var authCommand: AuthCommand = {
        AuthCommand(
            apiService: apiService,
            authTokenService: authTokenService,
            configProvider: configProvider
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
            configProvider: configProvider
        )
    }()

    private(set) lazy var fileManager: FileManager = {
        return .default
    }()

    // MARK: - Commands
    private(set) lazy var addCommand: AddCommand = {
        return AddCommand(apiService: apiService, configProvider: configProvider)
    }()
    
    private(set) lazy var deintegrateCommand: DeintegrateCommand = {
        return DeintegrateCommand(
            configFileLocation: configFileLocation,
            fileManager: fileManager
        )
    }()
    
    private(set) lazy var generateCommand: GenerateCommand = {
        return GenerateCommand(
            configProvider: configProvider,
            generatorPluginFactory: generatorPluginFactory
        )
    }()
    
    private(set) lazy var initCommand: InitCommand = {
        return InitCommand(
            projectDetector: CompositeProjectDetector(projectDetectors: [
                XcodeProjectDetector(fileManager: fileManager),
                GradleProjectDetector(fileManager: fileManager)
            ]),
            configProvider: configProvider,
            configFileLocation: configFileLocation,
            outputPathResolver: GeneratorOutputFilePathResolver(fileManager: fileManager)
        )
    }()
    
    private(set) lazy var listCommand: ListCommand = {
        return ListCommand(networkClient: networkClient, configProvider: configProvider)
    }()
    
    private(set) lazy var outdatedCommand: OutdatedCommand = {
        return OutdatedCommand(apiService: apiService, configProvider: configProvider)
    }()
    
    private(set) lazy var pullCommand: PullCommand = {
        return PullCommand(
            apiService: apiService,
            configProvider: configProvider,
            configFileLocation: configFileLocation,
            fileManager: fileManager
        )
    }()
    
    private(set) lazy var updateCommand: UpdateCommand = {
        return UpdateCommand(apiService: apiService, configProvider: configProvider)
    }()
    
    // MARK: - Private Initializer
    private init() {}
} 
