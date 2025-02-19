//
//  main.swift
//  eventpanel
//
//  Created by Sukhanov Evgenii on 19.02.2025.
//

import Foundation

// Entry point of the application
struct EventPanel {
    static func main() {
        let app = Application()
        app.run()
    }
}

// Main application class
final class Application {
    private let commandLineInterface: CommandLineInterface
    
    init() {
        self.commandLineInterface = CommandLineInterface()
    }
    
    func run() {
        commandLineInterface.start()
    }
}

// Start the application
EventPanel.main()

