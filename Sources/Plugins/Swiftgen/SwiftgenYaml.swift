//
//  SwiftgenYaml.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 08.05.2025.
//

struct SwiftgenYaml: Codable {
    struct JSONConfig: Codable {
        let inputs: String
        let outputs: OutputConfig
    }

    struct OutputConfig: Codable {
        let templatePath: String
        let output: String
        let params: OutputParams

        enum CodingKeys: String, CodingKey {
            case templatePath = "templatePath"
            case output
            case params
        }
    }

    struct OutputParams: Codable {
        let enumName: String
        let eventClassName: String
        let documentation: Bool
    }

    let json: JSONConfig
    
    enum CodingKeys: String, CodingKey {
        case json
    }
}
