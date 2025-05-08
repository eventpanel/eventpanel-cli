//
//  SwiftgenConfig.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 08.05.2025.
//

struct SwiftgenConfig: Codable {
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


    let inputDir: String
    let outputDir: String
    let json: JSONConfig
    
    enum CodingKeys: String, CodingKey {
        case inputDir = "input_dir"
        case outputDir = "output_dir"
        case json
    }
}
