import Foundation

protocol GeneratorPluginFactory {
    func generator(for plugin: Plugin) -> CodeGeneratorPlugin
}

final class DefaultGeneratorPluginFactory: GeneratorPluginFactory, @unchecked Sendable {
    private let configFileLocation: ConfigFileLocation
    private let fileManager: FileManager

    init(
        configFileLocation: ConfigFileLocation,
        fileManager: FileManager
    ) {
        self.configFileLocation = configFileLocation
        self.fileManager = fileManager
    }

    func generator(for plugin: Plugin) -> CodeGeneratorPlugin {
        switch plugin {
        case .swiftgen(let plugin):
            return SwiftGen(
                config: plugin,
                schemeManagerLoader: FileSchemeManagerLoader(
                    configFileLocation: configFileLocation,
                    fileManager: fileManager
                ),
                configFileLocation: configFileLocation,
                fileManager: fileManager
            )
        case .kotlingen(let plugin):
            return KotlinGen(
                config: plugin,
                schemeManagerLoader: FileSchemeManagerLoader(
                    configFileLocation: configFileLocation,
                    fileManager: fileManager
                ),
                configFileLocation: configFileLocation,
                fileManager: fileManager
            )
        }
    }
}
