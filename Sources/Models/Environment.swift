import Foundation

enum Environment: String, CaseIterable {
    case development = "development"
    case production = "production"
    
    var baseURL: URL {
        switch self {
        case .development:
            return URL(string: "http://localhost:3002/")!
        case .production:
            // Replace with your actual production URL
            return URL(string: "https://eventpanel.net/")!
        }
    }
    
    static var current: Environment {
        // Check environment variable first
        if let envString = ProcessInfo.processInfo.environment["EVENTPANEL_ENV"],
           let env = Environment(rawValue: envString.lowercased()) {
            return env
        }
        
        // Check for common development indicators
        if ProcessInfo.processInfo.environment["DEBUG"] != nil ||
           ProcessInfo.processInfo.environment["DEVELOPMENT"] != nil {
            return .development
        }
        
        // Default to development for safety
        return .development
    }
    
    static func from(string: String?) -> Environment {
        guard let string = string?.lowercased(),
              let env = Environment(rawValue: string) else {
            return .current
        }
        return env
    }
}
