import Foundation
import ArgumentParser

struct ConfigFileLocation {
    let configFilePath: URL
    let configDirectory: URL
    let workingDirectory: URL

    var cacheDirectory: URL {
        configDirectory.appendingPathComponent(".eventpanel")
    }

    init(configPath: String? = nil, workingDirectory: String = FileManager.default.currentDirectoryPath) {
        let filePath = configPath ?? (workingDirectory as NSString).appendingPathComponent("EventPanel.yaml")

        self.workingDirectory = URL(fileURLWithPath: workingDirectory)
        self.configDirectory = configPath.map { URL(fileURLWithPath: $0) }?.deletingLastPathComponent() ?? URL(fileURLWithPath: workingDirectory)
        self.configFilePath = URL(fileURLWithPath: filePath)
    }
}

actor ConfigFileLocationProvider {
    static private var _configFileLocation: ConfigFileLocation?
    
    static var configFileLocation: ConfigFileLocation {
        guard let location = _configFileLocation else {
            fatalError("ConfigFileLocationProvider not initialized. Call initialize() first.")
        }
        return location
    }
    
    static func initialize(configPath: String?, fileManager: FileManager = .default) throws {
        if let configPath = configPath {
            if !fileManager.fileExists(atPath: configPath) {
                throw ValidationError("Configuration file not found at path: \(configPath)")
            }
        }
        
        _configFileLocation = ConfigFileLocation(configPath: configPath)
    }
}
