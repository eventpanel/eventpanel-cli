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

        // Check if all characters in base name are valid file name characters
        guard baseName.allSatisfy({ isValidFileNameCharacter($0) }) else {
            throw SwiftFileNameValidationError.invalidCharacters
        }
    }

    private static func isValidSwiftIdentifierStart(_ character: Character?) -> Bool {
        guard let char = character else { return false }

        // Valid start characters: letters, underscore
        return char.isLetter || char == "_"
    }

    private static func isValidFileNameCharacter(_ character: Character) -> Bool {
        // Only forbid truly problematic macOS characters: : / \ ? * " < > |
        let forbiddenCharacters: Set<Character> = [":", "/", "\\", "?", "*", "\"", "<", ">", "|"]

        return !forbiddenCharacters.contains(character)
    }
}

enum SwiftFileNameValidationError: LocalizedError {
    case emptyFileName
    case missingSwiftExtension
    case emptyBaseName
    case invalidStartCharacter
    case invalidCharacters

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
            return "Filename contains forbidden characters (:, /, \\, ?, *, \", <, >, |)"
        }
    }
}
