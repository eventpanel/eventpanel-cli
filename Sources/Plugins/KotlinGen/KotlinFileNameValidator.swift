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
        
        // Check if all characters in base name are valid file name characters
        guard baseName.allSatisfy({ isValidFileNameCharacter($0) }) else {
            throw KotlinFileNameValidationError.invalidCharacters
        }
    }
    
    private static func isValidKotlinIdentifierStart(_ character: Character?) -> Bool {
        guard let char = character else { return false }
        
        // Valid start characters: letters, underscore, dollar sign
        return char.isLetter || char == "_" || char == "$"
    }
    
    private static func isValidFileNameCharacter(_ character: Character) -> Bool {
        // Only forbid truly problematic macOS characters: : / \ ? * " < > |
        let forbiddenCharacters: Set<Character> = [":", "/", "\\", "?", "*", "\"", "<", ">", "|"]
        
        return !forbiddenCharacters.contains(character)
    }
}

enum KotlinFileNameValidationError: LocalizedError {
    case emptyFileName
    case missingKotlinExtension
    case emptyBaseName
    case invalidStartCharacter
    case invalidCharacters
    
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
            return "Filename contains forbidden characters (:, /, \\, ?, *, \", <, >, |)"
        }
    }
}
