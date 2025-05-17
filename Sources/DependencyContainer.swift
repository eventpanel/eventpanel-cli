import Foundation

final class DependencyContainer: @unchecked Sendable {
    // MARK: - Shared Instance
    static let shared = DependencyContainer()
    
    // MARK: - Dependencies
    private(set) lazy var authCommand: AuthCommand = {
        return AuthCommand()
    }()
    
    private lazy var networkClient: NetworkClient = {
        do {
            let token = try authCommand.getToken()
            let authAPIClientDelegate = AuthAPIClientDelegate(accessToken: token)
            let networkClient = NetworkClient(baseURL: URL(string: "http://localhost:3002/")) {
                $0.delegate = authAPIClientDelegate
            }
            return networkClient
        } catch {
            fatalError("Failed to initialize network client: \(error.localizedDescription)")
        }
    }()
    
    private(set) lazy var fileManager: FileManager = {
        return .default
    }()

    private(set) lazy var eventPanelYaml: EventPanelYaml = {
        try! EventPanelYaml.read()
    }()

    // MARK: - Commands
    private(set) lazy var addCommand: AddCommand = {
        return AddCommand(networkClient: networkClient, eventPanelYaml: eventPanelYaml)
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
        return OutdatedCommand(networkClient: networkClient, eventPanelYaml: eventPanelYaml)
    }()
    
    private(set) lazy var pullCommand: PullCommand = {
        return PullCommand(networkClient: networkClient, eventPanelYaml: eventPanelYaml, fileManager: fileManager)
    }()
    
    private(set) lazy var updateCommand: UpdateCommand = {
        return UpdateCommand(networkClient: networkClient, eventPanelYaml: eventPanelYaml)
    }()
    
    // MARK: - Private Initializer
    private init() {}
} 
