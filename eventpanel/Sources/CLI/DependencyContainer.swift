import Foundation

final class DependencyContainer {
    // MARK: - Shared Instance
    static let shared = DependencyContainer()
    
    // MARK: - Dependencies
    private(set) lazy var networkClient: NetworkClient = {
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
    
    // MARK: - Commands
    private(set) lazy var addCommand: AddCommand = {
        return AddCommand(networkClient: networkClient)
    }()
    
    private(set) lazy var deintegrateCommand: DeintegrateCommand = {
        return DeintegrateCommand(fileManager: fileManager)
    }()
    
    private(set) lazy var generateCommand: GenerateCommand = {
        return GenerateCommand()
    }()
    
    private(set) lazy var initCommand: InitCommand = {
        return InitCommand(fileManager: fileManager)
    }()
    
    private(set) lazy var listCommand: ListCommand = {
        return ListCommand(networkClient: networkClient)
    }()
    
    private(set) lazy var outdatedCommand: OutdatedCommand = {
        return OutdatedCommand(networkClient: networkClient)
    }()
    
    private(set) lazy var pullCommand: PullCommand = {
        return PullCommand(networkClient: networkClient, fileManager: fileManager)
    }()
    
    private(set) lazy var updateCommand: UpdateCommand = {
        return UpdateCommand(networkClient: networkClient)
    }()
    
    // MARK: - Private Initializer
    private init() {}
} 
