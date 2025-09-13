import Foundation

final class DeintegrateCommand {
    private let configFileLocation: ConfigFileLocation
    private let fileManager: FileManager
    
    init(
        configFileLocation: ConfigFileLocation,
        fileManager: FileManager
    ) {
        self.configFileLocation = configFileLocation
        self.fileManager = fileManager
    }
    
    func execute() async throws {
        try removeConfigFile()
        try removeCacheFolder()

        ConsoleLogger.success("Successfully removed EventPanel.yaml")
    }

    private func removeConfigFile() throws {
        let configPath = configFileLocation.configFilePath.relativePath

        if fileManager.fileExists(atPath: configPath) {
            try fileManager.removeItem(atPath: configPath)
        } else {
            ConsoleLogger.error("No EventPanel.yaml found in current directory")
        }
    }

    private func removeCacheFolder() throws {
        let cacheFolder = configFileLocation.cacheDirectory.relativePath

        if fileManager.fileExists(atPath: cacheFolder) {
            try fileManager.removeItem(atPath: cacheFolder)
        }
    }
}
