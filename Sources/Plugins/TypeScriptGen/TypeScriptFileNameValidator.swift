import Foundation

struct TypeScriptFileNameValidator {
    static func validate(_ fileName: String) throws {
        // Check if filename is empty
        guard !fileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw TypeScriptFileNameValidationError.emptyFileName
        }

        let trimmedFileName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)

        // Check if filename has .ts extension
        guard trimmedFileName.hasSuffix(".ts") else {
            throw TypeScriptFileNameValidationError.missingTypeScriptExtension
        }

        // Remove .ts extension to validate the base name
        let baseName = String(trimmedFileName.dropLast(3)) // Remove ".ts"

        // Check if base name is empty after removing extension
        guard !baseName.isEmpty else {
            throw TypeScriptFileNameValidationError.emptyBaseName
        }

        // Check if base name starts with a valid TypeScript identifier character
        guard isValidTypeScriptIdentifierStart(baseName.first) else {
            throw TypeScriptFileNameValidationError.invalidStartCharacter
        }

        // Check if all characters in base name are valid file name characters
        guard baseName.allSatisfy({ isValidFileNameCharacter($0) }) else {
            throw TypeScriptFileNameValidationError.invalidCharacters
        }
    }

    private static func isValidTypeScriptIdentifierStart(_ character: Character?) -> Bool {
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

enum TypeScriptFileNameValidationError: LocalizedError {
    case emptyFileName
    case missingTypeScriptExtension
    case emptyBaseName
    case invalidStartCharacter
    case invalidCharacters

    var errorDescription: String? {
        switch self {
        case .emptyFileName:
            return "Filename cannot be empty"
        case .missingTypeScriptExtension:
            return "Filename must have .ts extension"
        case .emptyBaseName:
            return "Filename base name cannot be empty"
        case .invalidStartCharacter:
            return "Filename must start with a letter, underscore, or dollar sign"
        case .invalidCharacters:
            return "Filename contains forbidden characters (:, /, \\, ?, *, \", <, >, |)"
        }
    }
}
