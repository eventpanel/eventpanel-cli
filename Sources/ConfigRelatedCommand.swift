import Foundation

protocol ConfigRelatedCommand {
    func validateConfig() throws
}

extension ConfigRelatedCommand {
    func validateConfig() throws {
        _ = try EventPanelYaml.read()
    }
}
