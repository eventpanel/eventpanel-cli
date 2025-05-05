//
//  Swiftgen.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 05.05.2025.
//

import Foundation

actor Swiftgen: CodeGeneratorPlugin {
    func run() throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swiftgen"]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        if process.terminationStatus == 0 {
            ConsoleLogger.success("SwiftGen completed successfully")
        } else {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8) {
                throw GenerateCommandError.swiftgenFailed(output)
            }
            throw GenerateCommandError.swiftgenFailed("Unknown error")
        }
    }
}
