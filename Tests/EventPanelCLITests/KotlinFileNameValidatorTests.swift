import XCTest
@testable import eventpanel

final class KotlinFileNameValidatorTests: XCTestCase {
    
    // MARK: - Valid File Names
    
    func testValidFileName() throws {
        let fileName = "Events.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithUnderscore() throws {
        let fileName = "Analytics_Events.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithNumbers() throws {
        let fileName = "Event2.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameStartingWithUnderscore() throws {
        let fileName = "_PrivateEvents.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameStartingWithDollarSign() throws {
        let fileName = "$GeneratedEvents.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithDollarSign() throws {
        let fileName = "Events$Test.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithHyphen() throws {
        let fileName = "Events-File.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPeriod() throws {
        let fileName = "Events.File.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithMultiplePeriods() throws {
        let fileName = "Events.File.Utils.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPlus() throws {
        let fileName = "Events+File.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithSpace() throws {
        let fileName = "Events File.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithAtSign() throws {
        let fileName = "Events@File.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithHash() throws {
        let fileName = "Events#File.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithPercent() throws {
        let fileName = "Events%File.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithExclamation() throws {
        let fileName = "Events!File.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidFileNameWithWhitespace() throws {
        let fileName = "  Events.kt  "
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    // MARK: - Empty File Name Tests
    
    func testEmptyFileName() {
        let fileName = ""
        
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
        let fileName = "   "
        
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
        let fileName = "\n\t"
        
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
        let fileName = "Events"
        
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
        let fileName = "Events.txt"
        
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
        let fileName = "Events.KT"
        
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
        let fileName = ".kt"
        
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
        let fileName = "   .kt"
        
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
        let fileName = "2Events.kt"
        
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
        let fileName = "@Events.kt"
        
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
        let fileName = "-Events.kt"
        
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
        let fileName = "Events:File.kt"
        
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
        let fileName = "Events/File.kt"
        
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
        let fileName = "Events\\File.kt"
        
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
        let fileName = "Events?File.kt"
        
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
        let fileName = "Events*File.kt"
        
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
        let fileName = "Events\"File.kt"
        
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
        let fileName = "Events<File.kt"
        
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
        let fileName = "Events>File.kt"
        
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
        let fileName = "Events|File.kt"
        
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
        let fileName = "class.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFun() throws {
        let fileName = "fun.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordData() throws {
        let fileName = "data.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordEnum() throws {
        let fileName = "enum.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordInterface() throws {
        let fileName = "interface.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordPackage() throws {
        let fileName = "package.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordImport() throws {
        let fileName = "import.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordVal() throws {
        let fileName = "val.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordVar() throws {
        let fileName = "var.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordIf() throws {
        let fileName = "if.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFor() throws {
        let fileName = "for.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordWhile() throws {
        let fileName = "while.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordReturn() throws {
        let fileName = "return.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordTrue() throws {
        let fileName = "true.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordFalse() throws {
        let fileName = "false.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordNull() throws {
        let fileName = "null.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordWhen() throws {
        let fileName = "when.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordObject() throws {
        let fileName = "object.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordCompanion() throws {
        let fileName = "companion.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordSealed() throws {
        let fileName = "sealed.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordAbstract() throws {
        let fileName = "abstract.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordOpen() throws {
        let fileName = "open.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordInternal() throws {
        let fileName = "internal.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordPrivate() throws {
        let fileName = "private.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordProtected() throws {
        let fileName = "protected.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testValidReservedKeywordPublic() throws {
        let fileName = "public.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    // MARK: - Edge Cases
    
    func testVeryLongValidFileName() throws {
        let fileName = String(repeating: "A", count: 100) + ".kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithOnlyUnderscores() throws {
        let fileName = "___"
        
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
        let fileName = "___.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithOnlyDollarSigns() throws {
        let fileName = "$$$"
        
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
        let fileName = "$$$.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithNumbersAndUnderscores() throws {
        let fileName = "Event_123_Test.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithNumbersAndDollarSigns() throws {
        let fileName = "Event$123$Test.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
    
    func testFileNameWithMixedValidCharacters() throws {
        let fileName = "Event_123$Test_456.kt"
        
        XCTAssertNoThrow(try KotlinFileNameValidator.validate(fileName))
    }
}