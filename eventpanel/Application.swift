//
//  main.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 19.02.2025.
//

import Foundation

@main
struct EventPanel {
    static func main() async throws {
        let app = Application()
        await app.run()
    }
}

// Main application class
final class Application {
    private let commandLineInterface: CommandLineInterface
    
    init() {
        let authAPIClientDelegate = AuthAPIClientDelegate(
            accessToken: "n0MajbT5rzBVRp59NHvQ7IM9G3234zW2BlInzAVZ7BqamdxLWGr1s6tWht9eC0d2mGiS76PXyzb1pCkhWHVH6uRhNKvTZsxFHOwesdcZgAyO1hIsYA7RCU3iMPBL4oHb"
        )
        let networkClient = NetworkClient(baseURL: URL(string: "http://localhost:3002/")) {
            $0.delegate = authAPIClientDelegate
        }
        let commandRegistry = CommandRegistry(networkClient: networkClient)
        let commandProcessor = CommandProcessor(commandRegistry: commandRegistry)
        self.commandLineInterface = CommandLineInterface(
            commandProcessor: commandProcessor,
            commandRegistry: commandRegistry
        )
    }
    
    func run() async {
        await commandLineInterface.start()
    }
}
