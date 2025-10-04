import XCTest
@testable import eventpanel

final class TypeScriptFileNameValidatorTests: XCTestCase {

    // MARK: - Valid file names

    func testValidFileName() throws {
        XCTAssertNoThrow(try TypeScriptFileNameValidator.validate("ValidFileName.ts"))
    }

    func testValidFileNameWithUnderscore() throws {
        XCTAssertNoThrow(try TypeScriptFileNameValidator.validate("valid_file_name.ts"))
    }

    func testValidFileNameWithDollarSign() throws {
        XCTAssertNoThrow(try TypeScriptFileNameValidator.validate("$validFileName.ts"))
    }

    func testValidFileNameWithNumbers() throws {
        XCTAssertNoThrow(try TypeScriptFileNameValidator.validate("validFileName123.ts"))
    }

    func testValidFileNameWithHyphens() throws {
        XCTAssertNoThrow(try TypeScriptFileNameValidator.validate("valid-file-name.ts"))
    }

    func testValidFileNameWithSpaces() throws {
        XCTAssertNoThrow(try TypeScriptFileNameValidator.validate("valid file name.ts"))
    }

    // MARK: - Invalid file names

    func testEmptyFileName() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testMissingTypeScriptExtension() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("ValidFileName")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testWrongExtension() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("ValidFileName.js")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testEmptyBaseName() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate(".ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidStartCharacterWithNumber() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("123fileName.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidStartCharacterWithHyphen() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("-fileName.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidCharactersWithColon() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("file:name.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidCharactersWithSlash() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("file/name.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidCharactersWithBackslash() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("file\\name.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidCharactersWithQuestionMark() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("file?name.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidCharactersWithAsterisk() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("file*name.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidCharactersWithDoubleQuote() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("file\"name.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidCharactersWithLessThan() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("file<name.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidCharactersWithGreaterThan() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("file>name.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testInvalidCharactersWithPipe() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("file|name.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    // MARK: - Edge cases

    func testWhitespaceOnlyFileName() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("   ")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }

    func testFileNameWithWhitespaceAroundExtension() throws {
        XCTAssertNoThrow(try TypeScriptFileNameValidator.validate("fileName .ts"))
    }

    func testValidFileNameWithNumbersOnly() throws {
        XCTAssertThrowsError(try TypeScriptFileNameValidator.validate("123456.ts")) { error in
            XCTAssertTrue(error is TypeScriptFileNameValidationError)
        }
    }
}