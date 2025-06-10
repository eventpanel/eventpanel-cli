//
//  EventPanelYamlProvider.swift
//  eventpanel-cli
//
//  Created by Sukhanov Evgenii on 10.06.2025.
//

protocol EventPanelYamlProvider: Sendable {
    func read() async throws -> EventPanelYaml
}

final class FileEventPanelYamlProvider: EventPanelYamlProvider {
    func read() async throws -> EventPanelYaml {
        try EventPanelYaml.read(fileManager: .default)
    }
}
