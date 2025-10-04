import XCTest
@testable import eventpanel

final class SwiftFileNameValidatorTests: XCTestCase {
    
    // MARK: - Valid File Names
    
    func testValidFileName() throws {
        let fileName = "Events.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithUnderscore() throws {
        let fileName = "Analytics_Events.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithNumbers() throws {
        let fileName = "Event2.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameStartingWithUnderscore() throws {
        let fileName = "_PrivateEvents.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithWhitespace() throws {
        let fileName = "  Events.swift  "
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    // MARK: - Empty File Name Tests
    
    func testEmptyFileName() {
        let fileName = ""
        
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
        let fileName = "   "
        
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
        let fileName = "\n\t"
        
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
        let fileName = "Events"
        
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
        let fileName = "Events.txt"
        
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
        let fileName = "Events.SWIFT"
        
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
        let fileName = ".swift"
        
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
        let fileName = "   .swift"
        
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
        let fileName = "2Events.swift"
        
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
        let fileName = "@Events.swift"
        
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
        let fileName = "$Events.swift"
        
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
        let fileName = "Events-File.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPeriod() throws {
        let fileName = "Events.File.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithMultiplePeriods() throws {
        let fileName = "Events.File.Utils.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPlus() throws {
        let fileName = "Events+File.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithSpace() throws {
        let fileName = "Events File.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithAtSign() throws {
        let fileName = "Events@File.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithHash() throws {
        let fileName = "Events#File.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPercent() throws {
        let fileName = "Events%File.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithExclamation() throws {
        let fileName = "Events!File.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    
    func testInvalidCharactersColon() {
        let fileName = "Events:File.swift"
        
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
        let fileName = "Events/File.swift"
        
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
        let fileName = "Events\\File.swift"
        
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
        let fileName = "Events?File.swift"
        
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
        let fileName = "Events*File.swift"
        
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
        let fileName = "Events\"File.swift"
        
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
        let fileName = "Events<File.swift"
        
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
        let fileName = "Events>File.swift"
        
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
        let fileName = "Events|File.swift"
        
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
        let fileName = "class.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFunc() throws {
        let fileName = "func.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordStruct() throws {
        let fileName = "struct.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordEnum() throws {
        let fileName = "enum.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordProtocol() throws {
        let fileName = "protocol.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordImport() throws {
        let fileName = "import.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordVar() throws {
        let fileName = "var.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordLet() throws {
        let fileName = "let.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordIf() throws {
        let fileName = "if.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFor() throws {
        let fileName = "for.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordWhile() throws {
        let fileName = "while.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordReturn() throws {
        let fileName = "return.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordTrue() throws {
        let fileName = "true.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFalse() throws {
        let fileName = "false.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordNil() throws {
        let fileName = "nil.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    // MARK: - Edge Cases
    
    func testVeryLongValidFileName() throws {
        let fileName = String(repeating: "A", count: 100) + ".swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithOnlyUnderscores() throws {
        let fileName = "___"
        
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
        let fileName = "___.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithNumbersAndUnderscores() throws {
        let fileName = "Event_123_Test.swift"
        
        XCTAssertNoThrow(try SwiftFileNameValidator.validate(fileName))
    }
}
