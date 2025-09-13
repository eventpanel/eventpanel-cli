import XCTest
@testable import eventpanel

final class SwiftFileNameValidatorTests: XCTestCase {
    
    // MARK: - Valid File Names
    
    func testValidFileName() throws {
        // Given
        let fileName = "Events.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithUnderscore() throws {
        // Given
        let fileName = "Analytics_Events.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithNumbers() throws {
        // Given
        let fileName = "Event2.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameStartingWithUnderscore() throws {
        // Given
        let fileName = "_PrivateEvents.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithWhitespace() throws {
        // Given
        let fileName = "  Events.swift  "
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    // MARK: - Empty File Name Tests
    
    func testEmptyFileName() {
        // Given
        let fileName = ""
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.emptyFileName = error {
                // Expected error
            } else {
                XCTFail("Expected emptyFileName error")
            }
        }
    }
    
    func testWhitespaceOnlyFileName() {
        // Given
        let fileName = "   "
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.emptyFileName = error {
                // Expected error
            } else {
                XCTFail("Expected emptyFileName error")
            }
        }
    }
    
    func testNewlineOnlyFileName() {
        // Given
        let fileName = "\n\t"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.emptyFileName = error {
                // Expected error
            } else {
                XCTFail("Expected emptyFileName error")
            }
        }
    }
    
    // MARK: - Missing Extension Tests
    
    func testMissingSwiftExtension() {
        // Given
        let fileName = "Events"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.missingSwiftExtension = error {
                // Expected error
            } else {
                XCTFail("Expected missingSwiftExtension error")
            }
        }
    }
    
    func testWrongExtension() {
        // Given
        let fileName = "Events.txt"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.missingSwiftExtension = error {
                // Expected error
            } else {
                XCTFail("Expected missingSwiftExtension error")
            }
        }
    }
    
    func testCaseSensitiveExtension() {
        // Given
        let fileName = "Events.SWIFT"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.missingSwiftExtension = error {
                // Expected error
            } else {
                XCTFail("Expected missingSwiftExtension error")
            }
        }
    }
    
    // MARK: - Empty Base Name Tests
    
    func testEmptyBaseName() {
        // Given
        let fileName = ".swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.emptyBaseName = error {
                // Expected error
            } else {
                XCTFail("Expected emptyBaseName error")
            }
        }
    }
    
    func testWhitespaceBaseName() {
        // Given
        let fileName = "   .swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.emptyBaseName = error {
                // Expected error
            } else {
                XCTFail("Expected emptyBaseName error")
            }
        }
    }
    
    // MARK: - Invalid Start Character Tests
    
    func testInvalidStartCharacterNumber() {
        // Given
        let fileName = "2Events.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidStartCharacter = error {
                // Expected error
            } else {
                XCTFail("Expected invalidStartCharacter error")
            }
        }
    }
    
    func testInvalidStartCharacterSpecialChar() {
        // Given
        let fileName = "@Events.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidStartCharacter = error {
                // Expected error
            } else {
                XCTFail("Expected invalidStartCharacter error")
            }
        }
    }
    
    func testInvalidStartCharacterDollarSign() {
        // Given
        let fileName = "$Events.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidStartCharacter = error {
                // Expected error
            } else {
                XCTFail("Expected invalidStartCharacter error")
            }
        }
    }
    
    // MARK: - Invalid Characters Tests
    
    func testValidFileNameWithHyphen() throws {
        // Given
        let fileName = "Events-File.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPeriod() throws {
        // Given
        let fileName = "Events.File.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithMultiplePeriods() throws {
        // Given
        let fileName = "Events.File.Utils.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPlus() throws {
        // Given
        let fileName = "Events+File.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithSpace() throws {
        // Given
        let fileName = "Events File.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithAtSign() throws {
        // Given
        let fileName = "Events@File.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithHash() throws {
        // Given
        let fileName = "Events#File.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPercent() throws {
        // Given
        let fileName = "Events%File.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithExclamation() throws {
        // Given
        let fileName = "Events!File.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    
    func testInvalidCharactersColon() {
        // Given
        let fileName = "Events:File.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersSlash() {
        // Given
        let fileName = "Events/File.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersBackslash() {
        // Given
        let fileName = "Events\\File.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersQuestionMark() {
        // Given
        let fileName = "Events?File.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersAsterisk() {
        // Given
        let fileName = "Events*File.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersQuote() {
        // Given
        let fileName = "Events\"File.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersLessThan() {
        // Given
        let fileName = "Events<File.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersGreaterThan() {
        // Given
        let fileName = "Events>File.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersPipe() {
        // Given
        let fileName = "Events|File.swift"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    // MARK: - Valid Reserved Keyword File Names (These should now be valid)
    
    func testValidReservedKeywordClass() throws {
        // Given
        let fileName = "class.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFunc() throws {
        // Given
        let fileName = "func.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordStruct() throws {
        // Given
        let fileName = "struct.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordEnum() throws {
        // Given
        let fileName = "enum.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordProtocol() throws {
        // Given
        let fileName = "protocol.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordImport() throws {
        // Given
        let fileName = "import.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordVar() throws {
        // Given
        let fileName = "var.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordLet() throws {
        // Given
        let fileName = "let.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordIf() throws {
        // Given
        let fileName = "if.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFor() throws {
        // Given
        let fileName = "for.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordWhile() throws {
        // Given
        let fileName = "while.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordReturn() throws {
        // Given
        let fileName = "return.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordTrue() throws {
        // Given
        let fileName = "true.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFalse() throws {
        // Given
        let fileName = "false.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordNil() throws {
        // Given
        let fileName = "nil.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    // MARK: - Edge Cases
    
    func testVeryLongValidFileName() throws {
        // Given
        let fileName = String(repeating: "A", count: 100) + ".swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithOnlyUnderscores() throws {
        // Given
        let fileName = "___"
        
        // When & Then
        XCTAssertThrowsError(try SwiftFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
            if case SwiftFileNameValidationError.missingSwiftExtension = error {
                // Expected error
            } else {
                XCTFail("Expected missingSwiftExtension error")
            }
        }
    }
    
    func testFileNameWithOnlyUnderscoresAndExtension() throws {
        // Given
        let fileName = "___.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithNumbersAndUnderscores() throws {
        // Given
        let fileName = "Event_123_Test.swift"
        
        // When & Then
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
}
