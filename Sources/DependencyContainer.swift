import Foundation

final class DependencyContainer: @unchecked Sendable {
    // MARK: - Shared Instance
    static let shared = DependencyContainer()
    
    // MARK: - Dependencies
    private let authService: AuthService = {
        return AuthService()
    }()
    
    private(set) lazy var authCommand: AuthCommand = {
        return AuthCommand(authService: authService)
    }()
    
    private lazy var networkClient: NetworkClient = {
        let authAPIClientDelegate = AuthAPIClientDelegate(authService: authService)
        let networkClient = NetworkClient(baseURL: URL(string: "http://localhost:3002/")) {
            $0.delegate = authAPIClientDelegate
        }
        return networkClient
    }()
    
    private lazy var apiService: EventPanelAPIService = {
        return EventPanelAPIService(networkClient: networkClient)
    }()
    
    private(set) lazy var fileManager: FileManager = {
        return .default
    }()

    private(set) lazy var eventPanelYaml: EventPanelYaml = {
        try! EventPanelYaml.read()
    }()

    // MARK: - Commands
    private(set) lazy var addCommand: AddCommand = {
        return AddCommand(apiService: apiService, eventPanelYaml: eventPanelYaml)
    }()
    
    private(set) lazy var deintegrateCommand: DeintegrateCommand = {
        return DeintegrateCommand(fileManager: fileManager)
    }()
    
    private(set) lazy var generateCommand: GenerateCommand = {
        return GenerateCommand(eventPanelYaml: eventPanelYaml)
    }()
    
    private(set) lazy var initCommand: InitCommand = {
        return InitCommand(fileManager: fileManager)
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
