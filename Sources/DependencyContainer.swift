import Foundation

final class DependencyContainer: @unchecked Sendable {
    // MARK: - Shared Instance
    static let shared = DependencyContainer()
    
    // MARK: - Dependencies
    private let networkClient: NetworkClient = {
        let authAPIClientDelegate = AuthAPIClientDelegate(
            accessToken: "n0MajbT5rzBVRp59NHvQ7IM9G3234zW2BlInzAVZ7BqamdxLWGr1s6tWht9eC0d2mGiS76PXyzb1pCkhWHVH6uRhNKvTZsxFHOwesdcZgAyO1hIsYA7RCU3iMPBL4oHb"
        )
        let networkClient = NetworkClient(baseURL: URL(string: "http://localhost:3002/")) {
            $0.delegate = authAPIClientDelegate
        }
        return networkClient
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
