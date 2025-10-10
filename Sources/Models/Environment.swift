import Foundation

enum Environment: String, CaseIterable {
    case development = "development"
    case production = "production"

    var baseURL: URL {
        switch self {
        case .development:
            return URL(string: "http://localhost:3002/")!
        case .production:
            return URL(string: "https://eventpanel.net/")!
        }
    }

    static var current: Environment {
        if let envString = ProcessInfo.processInfo.environment["EVENTPANEL_ENV"],
           let env = Environment(rawValue: envString.lowercased()) {
            return env
        }

        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}
