//
//  ConfigRelatedCommand.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 08.05.2025.
//

import Foundation

protocol ConfigRelatedCommand {
    func validateConfig() throws
}

extension ConfigRelatedCommand {
    func validateConfig() throws {
        _ = try EventPanelYaml.read()
    }
}
