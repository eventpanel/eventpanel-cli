import Foundation

struct SwiftFileNameValidator {
    static func validate(_ fileName: String) throws {
        // Check if filename is empty
        guard !fileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SwiftFileNameValidationError.emptyFileName
        }
        
        let trimmedFileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if filename has .swift extension
        guard trimmedFileName.hasSuffix(".swift") else {
            throw SwiftFileNameValidationError.missingSwiftExtension
        }
        
        // Remove .swift extension to validate the base name
        let baseName = String(trimmedFileName.dropLast(6)) // Remove ".swift"
        
        // Check if base name is empty after removing extension
        guard !baseName.isEmpty else {
            throw SwiftFileNameValidationError.emptyBaseName
        }
        
        // Check if base name starts with a valid Swift identifier character
        guard isValidSwiftIdentifierStart(baseName.first) else {
            throw SwiftFileNameValidationError.invalidStartCharacter
        }
        
        // Check if all characters in base name are valid Swift identifier characters
        guard baseName.allSatisfy({ isValidSwiftIdentifierCharacter($0) }) else {
            throw SwiftFileNameValidationError.invalidCharacters
        }
        
        // Check if filename is a reserved Swift keyword
        if isReservedSwiftKeyword(baseName) {
            throw SwiftFileNameValidationError.reservedKeyword
        }
    }
    
    private static func isValidSwiftIdentifierStart(_ character: Character?) -> Bool {
        guard let char = character else { return false }
        
        // Valid start characters: letters, underscore
        return char.isLetter || char == "_"
    }
    
    private static func isValidSwiftIdentifierCharacter(_ character: Character) -> Bool {
        // Valid characters: letters, digits, underscore
        return character.isLetter || character.isNumber || character == "_"
    }
    
    private static func isReservedSwiftKeyword(_ name: String) -> Bool {
        let reservedKeywords = [
            "associatedtype", "class", "deinit", "enum", "extension", "fileprivate",
            "func", "import", "init", "inout", "internal", "let", "open", "operator",
            "private", "protocol", "public", "static", "struct", "subscript", "typealias",
            "var", "break", "case", "continue", "default", "defer", "do", "else",
            "fallthrough", "for", "guard", "if", "in", "repeat", "return", "switch",
            "where", "while", "as", "catch", "dynamicType", "false", "is", "nil",
            "rethrows", "super", "self", "Self", "throw", "throws", "true", "try",
            "associativity", "convenience", "dynamic", "didSet", "final", "get", "infix",
            "indirect", "lazy", "left", "mutating", "none", "nonmutating", "optional",
            "override", "postfix", "precedence", "prefix", "Protocol", "required",
            "right", "set", "Type", "unowned", "weak", "willSet"
        ]
        
        return reservedKeywords.contains(name)
    }
}

enum SwiftFileNameValidationError: LocalizedError {
    case emptyFileName
    case missingSwiftExtension
    case emptyBaseName
    case invalidStartCharacter
    case invalidCharacters
    case reservedKeyword
    
    var errorDescription: String? {
        switch self {
        case .emptyFileName:
            return "Filename cannot be empty"
        case .missingSwiftExtension:
            return "Filename must have .swift extension"
        case .emptyBaseName:
            return "Filename base name cannot be empty"
        case .invalidStartCharacter:
            return "Filename must start with a letter or underscore"
        case .invalidCharacters:
            return "Filename can only contain letters, numbers, and underscores"
        case .reservedKeyword:
            return "Filename cannot be a reserved Swift keyword"
        }
    }
}
