//
//  Platform 2.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 05.05.2025.
//

enum Plugin: String, Codable {
    case swiftgen

    var generator: CodeGeneratorPlugin {
        switch self {
        case .swiftgen:
            return Swiftgen()
        }
    }
}
