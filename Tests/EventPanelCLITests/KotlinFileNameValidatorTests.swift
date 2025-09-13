import XCTest
@testable import eventpanel

final class KotlinFileNameValidatorTests: XCTestCase {
    
    // MARK: - Valid File Names
    
    func testValidFileName() throws {
        // Given
        let fileName = "Events.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithUnderscore() throws {
        // Given
        let fileName = "Analytics_Events.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithNumbers() throws {
        // Given
        let fileName = "Event2.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameStartingWithUnderscore() throws {
        // Given
        let fileName = "_PrivateEvents.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameStartingWithDollarSign() throws {
        // Given
        let fileName = "$GeneratedEvents.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithDollarSign() throws {
        // Given
        let fileName = "Events$Test.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithHyphen() throws {
        // Given
        let fileName = "Events-File.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPeriod() throws {
        // Given
        let fileName = "Events.File.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithMultiplePeriods() throws {
        // Given
        let fileName = "Events.File.Utils.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPlus() throws {
        // Given
        let fileName = "Events+File.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithSpace() throws {
        // Given
        let fileName = "Events File.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithAtSign() throws {
        // Given
        let fileName = "Events@File.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithHash() throws {
        // Given
        let fileName = "Events#File.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPercent() throws {
        // Given
        let fileName = "Events%File.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithExclamation() throws {
        // Given
        let fileName = "Events!File.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithWhitespace() throws {
        // Given
        let fileName = "  Events.kt  "
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    // MARK: - Empty File Name Tests
    
    func testEmptyFileName() {
        // Given
        let fileName = ""
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.emptyFileName = error {
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
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.emptyFileName = error {
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
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.emptyFileName = error {
                // Expected error
            } else {
                XCTFail("Expected emptyFileName error")
            }
        }
    }
    
    // MARK: - Missing Extension Tests
    
    func testMissingKotlinExtension() {
        // Given
        let fileName = "Events"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.missingKotlinExtension = error {
                // Expected error
            } else {
                XCTFail("Expected missingKotlinExtension error")
            }
        }
    }
    
    func testWrongExtension() {
        // Given
        let fileName = "Events.txt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.missingKotlinExtension = error {
                // Expected error
            } else {
                XCTFail("Expected missingKotlinExtension error")
            }
        }
    }
    
    func testCaseSensitiveExtension() {
        // Given
        let fileName = "Events.KT"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.missingKotlinExtension = error {
                // Expected error
            } else {
                XCTFail("Expected missingKotlinExtension error")
            }
        }
    }
    
    // MARK: - Empty Base Name Tests
    
    func testEmptyBaseName() {
        // Given
        let fileName = ".kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.emptyBaseName = error {
                // Expected error
            } else {
                XCTFail("Expected emptyBaseName error")
            }
        }
    }
    
    func testWhitespaceBaseName() {
        // Given
        let fileName = "   .kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.emptyBaseName = error {
                // Expected error
            } else {
                XCTFail("Expected emptyBaseName error")
            }
        }
    }
    
    // MARK: - Invalid Start Character Tests
    
    func testInvalidStartCharacterNumber() {
        // Given
        let fileName = "2Events.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidStartCharacter = error {
                // Expected error
            } else {
                XCTFail("Expected invalidStartCharacter error")
            }
        }
    }
    
    func testInvalidStartCharacterSpecialChar() {
        // Given
        let fileName = "@Events.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidStartCharacter = error {
                // Expected error
            } else {
                XCTFail("Expected invalidStartCharacter error")
            }
        }
    }
    
    func testInvalidStartCharacterHyphen() {
        // Given
        let fileName = "-Events.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidStartCharacter = error {
                // Expected error
            } else {
                XCTFail("Expected invalidStartCharacter error")
            }
        }
    }
    
    // MARK: - Invalid Characters Tests (macOS Forbidden Characters)
    
    
    func testInvalidCharactersColon() {
        // Given
        let fileName = "Events:File.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersSlash() {
        // Given
        let fileName = "Events/File.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersBackslash() {
        // Given
        let fileName = "Events\\File.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersQuestionMark() {
        // Given
        let fileName = "Events?File.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersAsterisk() {
        // Given
        let fileName = "Events*File.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersQuote() {
        // Given
        let fileName = "Events\"File.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersLessThan() {
        // Given
        let fileName = "Events<File.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersGreaterThan() {
        // Given
        let fileName = "Events>File.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    func testInvalidCharactersPipe() {
        // Given
        let fileName = "Events|File.kt"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.invalidCharacters = error {
                // Expected error
            } else {
                XCTFail("Expected invalidCharacters error")
            }
        }
    }
    
    // MARK: - Valid Reserved Keyword File Names (These should now be valid)
    
    func testValidReservedKeywordClass() throws {
        // Given
        let fileName = "class.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFun() throws {
        // Given
        let fileName = "fun.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordData() throws {
        // Given
        let fileName = "data.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordEnum() throws {
        // Given
        let fileName = "enum.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordInterface() throws {
        // Given
        let fileName = "interface.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordPackage() throws {
        // Given
        let fileName = "package.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordImport() throws {
        // Given
        let fileName = "import.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordVal() throws {
        // Given
        let fileName = "val.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordVar() throws {
        // Given
        let fileName = "var.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordIf() throws {
        // Given
        let fileName = "if.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFor() throws {
        // Given
        let fileName = "for.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordWhile() throws {
        // Given
        let fileName = "while.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordReturn() throws {
        // Given
        let fileName = "return.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordTrue() throws {
        // Given
        let fileName = "true.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFalse() throws {
        // Given
        let fileName = "false.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordNull() throws {
        // Given
        let fileName = "null.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordWhen() throws {
        // Given
        let fileName = "when.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordObject() throws {
        // Given
        let fileName = "object.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordCompanion() throws {
        // Given
        let fileName = "companion.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordSealed() throws {
        // Given
        let fileName = "sealed.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordAbstract() throws {
        // Given
        let fileName = "abstract.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordOpen() throws {
        // Given
        let fileName = "open.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordInternal() throws {
        // Given
        let fileName = "internal.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordPrivate() throws {
        // Given
        let fileName = "private.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordProtected() throws {
        // Given
        let fileName = "protected.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordPublic() throws {
        // Given
        let fileName = "public.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    // MARK: - Edge Cases
    
    func testVeryLongValidFileName() throws {
        // Given
        let fileName = String(repeating: "A", count: 100) + ".kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithOnlyUnderscores() throws {
        // Given
        let fileName = "___"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.missingKotlinExtension = error {
                // Expected error
            } else {
                XCTFail("Expected missingKotlinExtension error")
            }
        }
    }
    
    func testFileNameWithOnlyUnderscoresAndExtension() throws {
        // Given
        let fileName = "___.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithOnlyDollarSigns() throws {
        // Given
        let fileName = "$$$"
        
        // When & Then
        XCTAssertThrowsError(try KotlinFileNameValidator.validate(fileName)) { error in
            XCTAssertTrue(error is KotlinFileNameValidationError)
            if case KotlinFileNameValidationError.missingKotlinExtension = error {
                // Expected error
            } else {
                XCTFail("Expected missingKotlinExtension error")
            }
        }
    }
    
    func testFileNameWithOnlyDollarSignsAndExtension() throws {
        // Given
        let fileName = "$$$.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithNumbersAndUnderscores() throws {
        // Given
        let fileName = "Event_123_Test.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithNumbersAndDollarSigns() throws {
        // Given
        let fileName = "Event$123$Test.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithMixedValidCharacters() throws {
        // Given
        let fileName = "Event_123$Test_456.kt"
        
        // When & Then
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
}