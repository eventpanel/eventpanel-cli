import Foundation

protocol GeneratorPluginFactory {
    func generator(for plugin: Plugin) -> CodeGeneratorPlugin
}

final class DefaultGeneratorPluginFactory: GeneratorPluginFactory, @unchecked Sendable {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func generator(for plugin: Plugin) -> CodeGeneratorPlugin {
        switch plugin {
        case .swiftgen(let plugin):
            return SwiftGen(
                config: plugin,
                schemeManagerLoader: FileSchemeManagerLoader(
                    fileManager: fileManager
                ),
                fileManager: fileManager
            )
        }
    }
}
