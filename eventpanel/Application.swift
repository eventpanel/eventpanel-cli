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
        self.commandLineInterface = CommandLineInterface()
    }
    
    func run() async {
        await commandLineInterface.start()
    }
}
