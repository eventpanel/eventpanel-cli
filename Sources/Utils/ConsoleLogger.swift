final class ConsoleLogger {
    private static let red = "\u{001B}[31m"
    private static let green = "\u{001B}[32m"
    private static let yellow = "\u{001B}[33m"
    private static let reset = "\u{001B}[0m"

    nonisolated(unsafe) static var isVerbose = false

    static func error(
        _ message: String,
        separator: String = " ",
        terminator: String = "\n"
    ) {
        print("\(red)[!] \(message)\(reset)", separator: separator, terminator: terminator)
    }

    static func success(
        _ message: String,
        separator: String = " ",
        terminator: String = "\n"
    ) {
        print("\(green)\(message)\(reset)", separator: separator, terminator: terminator)
    }

    static func warning(
        _ message: String,
        separator: String = " ",
        terminator: String = "\n"
    ) {
        print("\(yellow)[!] \(message)\(reset)", separator: separator, terminator: terminator)
    }

    static func message(
        _ message: String,
        separator: String = " ",
        terminator: String = "\n"
    ) {
        print(message, separator: separator, terminator: terminator)
    }

    static func debug(_ message: String) {
        #if DEBUG
        print(message)
        #else
        if isVerbose {
            print(message)
        }
        #endif
    }
}
