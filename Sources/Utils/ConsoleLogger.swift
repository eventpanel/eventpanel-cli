actor ConsoleLogger {
    private static let red = "\u{001B}[31m"
    private static let green = "\u{001B}[32m"
    private static let yellow = "\u{001B}[33m"
    private static let reset = "\u{001B}[0m"

    public static var isVerbose = false
    
    static func error(_ message: String) {
        print("\(red)[!] \(message)\(reset)")
    }
    
    static func success(_ message: String) {
        print("\(green)\(message)\(reset)")
    }
    
    static func warning(_ message: String) {
        print("\(yellow)[!] \(message)\(reset)")
    }
    
    static func message(_ message: String) {
        print(message)
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
