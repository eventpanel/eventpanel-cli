import Foundation
import Get

enum ListCommandError: LocalizedError {
    case invalidPageSize(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidPageSize(let size):
            return "Invalid page size: \(size). Must be a positive number."
        }
    }
}

final class ListCommand {
    private let networkClient: NetworkClient
    private let eventPanelYaml: EventPanelYaml
    
    init(networkClient: NetworkClient, eventPanelYaml: EventPanelYaml) {
        self.networkClient = networkClient
        self.eventPanelYaml = eventPanelYaml
    }
    
    func execute(pageSize: Int) async throws {
        let events = await eventPanelYaml.getEvents()
        
        // Display events with pagination
        displayEvents(events, pageSize: pageSize)
    }
    
    private func displayEvents(_ events: [Event], pageSize: Int) {
        if events.isEmpty {
            ConsoleLogger.message("No events found")
            return
        }
        
        let totalPages = (events.count + pageSize - 1) / pageSize
        var currentPage = 1
        
        while true {
            let startIndex = (currentPage - 1) * pageSize
            let endIndex = min(startIndex + pageSize, events.count)
            let pageEvents = events[startIndex..<endIndex]
            
            // Print header
            ConsoleLogger.message("\nEvents (Page \(currentPage)/\(totalPages)):")
            ConsoleLogger.message("Event ID".padding(toLength: 40, withPad: " ", startingAt: 0) + "Version")
            ConsoleLogger.message(String(repeating: "-", count: 50))
            
            // Print events
            for event in pageEvents {
                let eventStr = event.name.padding(toLength: 40, withPad: " ", startingAt: 0)
                let versionStr = String(event.version ?? 1)
                ConsoleLogger.message("\(eventStr)\(versionStr)")
            }
            
            // Handle pagination
            if currentPage == totalPages {
                break
            }
            
            ConsoleLogger.message("\nPress 'n' for next page, 'p' for previous page, or 'q' to quit")
            if let input = readLine()?.lowercased() {
                switch input {
                case "n":
                    currentPage = min(currentPage + 1, totalPages)
                case "p":
                    currentPage = max(currentPage - 1, 1)
                case "q":
                    return
                default:
                    continue
                }
            }
        }
    }
} 
