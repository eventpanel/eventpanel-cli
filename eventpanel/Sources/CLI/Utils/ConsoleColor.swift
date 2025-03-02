enum ConsoleColor {
    static let red = "\u{001B}[31m"
    static let green = "\u{001B}[32m"
    static let yellow = "\u{001B}[33m"
    static let reset = "\u{001B}[0m"

    static func error(_ message: String) -> String {
        return "\(red)\(message)\(reset)"
    }

    static func success(_ message: String) -> String {
        return "\(green)\(message)\(reset)"
    }

    static func warning(_ message: String) -> String {
        return "\(yellow)\(message)\(reset)"
    }
}
