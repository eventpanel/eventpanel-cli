import Foundation

struct KotlinFileNameValidator {
    static func validate(_ fileName: String) throws {
        // Check if filename is empty
        guard !fileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw KotlinFileNameValidationError.emptyFileName
        }
        
        let trimmedFileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if filename has .kt extension
        guard trimmedFileName.hasSuffix(".kt") else {
            throw KotlinFileNameValidationError.missingKotlinExtension
        }
        
        // Remove .kt extension to validate the base name
        let baseName = String(trimmedFileName.dropLast(3)) // Remove ".kt"
        
        // Check if base name is empty after removing extension
        guard !baseName.isEmpty else {
            throw KotlinFileNameValidationError.emptyBaseName
        }
        
        // Check if base name starts with a valid Kotlin identifier character
        guard isValidKotlinIdentifierStart(baseName.first) else {
            throw KotlinFileNameValidationError.invalidStartCharacter
        }
        
        // Check if all characters in base name are valid Kotlin identifier characters
        guard baseName.allSatisfy({ isValidKotlinIdentifierCharacter($0) }) else {
            throw KotlinFileNameValidationError.invalidCharacters
        }
        
        // Check if filename is a reserved Kotlin keyword
        if isReservedKotlinKeyword(baseName) {
            throw KotlinFileNameValidationError.reservedKeyword
        }
    }
    
    private static func isValidKotlinIdentifierStart(_ character: Character?) -> Bool {
        guard let char = character else { return false }
        
        // Valid start characters: letters, underscore, dollar sign
        return char.isLetter || char == "_" || char == "$"
    }
    
    private static func isValidKotlinIdentifierCharacter(_ character: Character) -> Bool {
        // Valid characters: letters, digits, underscore, dollar sign
        return character.isLetter || character.isNumber || character == "_" || character == "$"
    }
    
    private static func isReservedKotlinKeyword(_ name: String) -> Bool {
        let reservedKeywords = [
            "as", "break", "class", "continue", "do", "else", "false", "for", "fun",
            "if", "in", "interface", "is", "null", "object", "package", "return",
            "super", "this", "throw", "true", "try", "typealias", "typeof", "val",
            "var", "when", "while", "by", "catch", "constructor", "delegate",
            "dynamic", "field", "file", "finally", "get", "import", "init", "param",
            "property", "receiver", "set", "setparam", "where", "actual", "annotation",
            "companion", "const", "crossinline", "data", "enum", "external", "final",
            "infix", "inline", "inner", "internal", "lateinit", "noinline", "open",
            "operator", "out", "override", "private", "protected", "public", "reified",
            "sealed", "suspend", "tailrec", "vararg", "abstract", "expect", "sealed"
        ]
        
        return reservedKeywords.contains(name)
    }
}

enum KotlinFileNameValidationError: LocalizedError {
    case emptyFileName
    case missingKotlinExtension
    case emptyBaseName
    case invalidStartCharacter
    case invalidCharacters
    case reservedKeyword
    
    var errorDescription: String? {
        switch self {
        case .emptyFileName:
            return "Filename cannot be empty"
        case .missingKotlinExtension:
            return "Filename must have .kt extension"
        case .emptyBaseName:
            return "Filename base name cannot be empty"
        case .invalidStartCharacter:
            return "Filename must start with a letter, underscore, or dollar sign"
        case .invalidCharacters:
            return "Filename can only contain letters, numbers, underscores, and dollar signs"
        case .reservedKeyword:
            return "Filename cannot be a reserved Kotlin keyword"
        }
    }
}
