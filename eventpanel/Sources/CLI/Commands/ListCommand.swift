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

struct ListCommandArgs {
    let pageSize: Int
}

final class ListCommand: Command {
    let name = "list"
    let description = "List events (use --page-size to set items per page)"
    
    private let networkClient: NetworkClient
    private let pageSize: Int
    
    init(networkClient: NetworkClient, pageSize: Int = 20) {
        self.networkClient = networkClient
        self.pageSize = pageSize
    }
    
    func execute(with arguments: [String]) async throws {
        let eventPanelYaml = try EventPanelYaml.read()
        
        // Parse arguments
        let args = try parseArguments(arguments)

        let events = eventPanelYaml.getEvents()
        
        // Display events with pagination
        displayEvents(events, pageSize: args.pageSize)
    }
    
    // MARK: - Private Methods
    
    private func parseArguments(_ arguments: [String]) throws -> ListCommandArgs {
        var pageSize = self.pageSize
        
        var i = 0
        while i < arguments.count {
            switch arguments[i] {
            case "--page-size":
                guard i + 1 < arguments.count,
                      let size = Int(arguments[i + 1]),
                      size > 0 else {
                    throw ListCommandError.invalidPageSize(arguments[i + 1])
                }
                pageSize = size
                i += 2
                
            default:
                i += 1
            }
        }
        
        return ListCommandArgs(pageSize: pageSize)
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
