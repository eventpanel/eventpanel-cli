import Foundation
import Get

enum ListCommandError: LocalizedError {
    case targetNotFound(String)
    case invalidPageSize(String)
    
    var errorDescription: String? {
        switch self {
        case .targetNotFound(let target):
            return "Target '\(target)' not found in configuration"
        case .invalidPageSize(let size):
            return "Invalid page size: \(size). Must be a positive number."
        }
    }
}

final class ListCommand: Command {
    let name = "list"
    let description = "List events (use --target to filter by target, --page-size to set items per page)"
    
    private let networkClient: NetworkClient
    private let pageSize: Int
    
    init(networkClient: NetworkClient, pageSize: Int = 20) {
        self.networkClient = networkClient
        self.pageSize = pageSize
    }
    
    func execute(with arguments: [String]) async throws {
        let eventPanelYaml = try EventPanelYaml.read()
        let targets = eventPanelYaml.getTargets()
        
        // Parse arguments
        let (target, pageSize) = try parseArguments(arguments, from: targets)
        
        // Get events for specified target or all targets
        let events = try await getEvents(
            target: target,
            targets: targets,
            using: eventPanelYaml
        )
        
        // Display events with pagination
        displayEvents(events, pageSize: pageSize)
    }
    
    // MARK: - Private Methods
    
    private func parseArguments(_ arguments: [String], from targets: [String]) throws -> (target: String?, pageSize: Int) {
        var target: String?
        var pageSize = self.pageSize
        
        var i = 0
        while i < arguments.count {
            switch arguments[i] {
            case "--target":
                guard i + 1 < arguments.count else {
                    throw ListCommandError.targetNotFound("")
                }
                let targetName = arguments[i + 1]
                guard targets.contains(targetName) else {
                    throw ListCommandError.targetNotFound(targetName)
                }
                target = targetName
                i += 2
                
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
        
        return (target, pageSize)
    }
    
    private func getEvents(
        target: String?,
        targets: [String],
        using eventPanelYaml: EventPanelYaml
    ) async throws -> [(target: String, event: Event)] {
        var events: [(target: String, event: Event)] = []
        let targetsToCheck = target.map { [$0] } ?? targets
        
        for target in targetsToCheck {
            let targetEvents = try eventPanelYaml.getEvents(for: target)
            events.append(contentsOf: targetEvents.map { (target: target, event: $0) })
        }
        
        return events.sorted { $0.event.name < $1.event.name }
    }
    
    private func displayEvents(_ events: [(target: String, event: Event)], pageSize: Int) {
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
            ConsoleLogger.message("Target".padding(toLength: 30, withPad: " ", startingAt: 0) + "Event ID".padding(toLength: 40, withPad: " ", startingAt: 0) + "Version")
            ConsoleLogger.message(String(repeating: "-", count: 80))
            
            // Print events
            for (target, event) in pageEvents {
                let targetStr = target.padding(toLength: 30, withPad: " ", startingAt: 0)
                let eventStr = event.name.padding(toLength: 40, withPad: " ", startingAt: 0)
                let versionStr = String(event.version ?? 1)
                ConsoleLogger.message("\(targetStr)\(eventStr)\(versionStr)")
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
