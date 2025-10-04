import Foundation
import ArgumentParser

struct ConfigFileLocation {
    let configFilePath: URL
    let configDirectory: URL
    let workingDirectory: URL

    var cacheDirectory: URL {
        configDirectory.appendingPathComponent(".eventpanel")
    }

    static var configName: String { "EventPanel.yaml" }

    init(
        configPath: String? = nil,
        workingDirectory: String
    ) {
        let filePath = configPath ?? (workingDirectory as NSString).appendingPathComponent(Self.configName)

        self.workingDirectory = URL(fileURLWithPath: workingDirectory)
        self.configDirectory = configPath.map { URL(fileURLWithPath: $0) }?.deletingLastPathComponent() ?? URL(fileURLWithPath: workingDirectory)
        self.configFilePath = URL(fileURLWithPath: filePath)
    }
}

actor ConfigFileLocationProvider {
    static nonisolated(unsafe) private var _configFileLocation: ConfigFileLocation?
    
    static var configFileLocation: ConfigFileLocation {
        guard let location = _configFileLocation else {
            fatalError("ConfigFileLocationProvider not initialized. Call initialize() first.")
        }
        return location
    }
    
    static func initialize(
        configPath: String?,
        workDir: String?,
        fileManager: FileManager = .default
    ) throws {
        if let configPath {
            if !fileManager.fileExists(atPath: configPath) {
                throw ValidationError("Configuration file not found at path: \(configPath)")
            }
        }

        if let workDir {
            if !fileManager.fileExists(atPath: workDir) {
                throw ValidationError("Working directory not exist: \(workDir)")
            }
        }

        _configFileLocation = ConfigFileLocation(
            configPath: configPath,
            workingDirectory: workDir ?? fileManager.currentDirectoryPath
        )
    }
}
