import XCTest
@testable import eventpanel

final class OutputPathValidatorTests: XCTestCase {
    
    private var validator: DefaultOutputPathValidator!
    private var tempDirectory: URL!
    
    override func setUp() {
        super.setUp()
        validator = DefaultOutputPathValidator()
        
        // Create a temporary directory for testing
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent("OutputPathValidatorTests")
            .appendingPathComponent(UUID().uuidString)
        
        try? FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
    }
    
    override func tearDown() {
        // Clean up the temporary directory
        try? FileManager.default.removeItem(at: tempDirectory)
        super.tearDown()
    }
    
    // MARK: - Valid Path Tests
    
    func testValidPath() throws {
        // Given
        let outputPath = "Events.swift"
        let source = Source.iOS
        
        // When
        let result = try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)
        
        // Then
        XCTAssertEqual(result, "Events.swift")
    }
    
    func testValidNestedPath() throws {
        // Given
        let outputPath = "Analytics/Events.swift"
        let source = Source.iOS
        
        // When
        let result = try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)
        
        // Then
        XCTAssertEqual(result, "Analytics/Events.swift")
    }
    
    func testValidDeeplyNestedPath() throws {
        // Given
        let outputPath = "Features/Analytics/Events/EventTracker.swift"
        let source = Source.iOS
        
        // When
        let result = try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)
        
        // Then
        XCTAssertEqual(result, "Features/Analytics/Events/EventTracker.swift")
    }
    
    func testValidKotlinPath() throws {
        // Given
        let outputPath = "Analytics/Events.kt"
        let source = Source.android
        
        // When
        let result = try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)
        
        // Then
        XCTAssertEqual(result, "Analytics/Events.kt")
    }
    
    // MARK: - Directory Traversal Attack Tests
    
    func testDirectoryTraversalWithDoubleDots() {
        // Given
        let outputPath = "../../../etc/passwd"
        let source = Source.iOS
        
        // When & Then
        XCTAssertThrowsError(try validator.validate(outputPath, for: source, workingDirectory: tempDirectory))
    }
    
    func testDirectoryTraversalWithMultipleDoubleDots() {
        // Given
        let outputPath = "Analytics/../../../etc/passwd"
        let source = Source.iOS
        
        // When & Then
        XCTAssertThrowsError(try validator.validate(outputPath, for: source, workingDirectory: tempDirectory))
    }
    
    func testDirectoryTraversalWithAbsolutePath() {
        // Given
        let outputPath = "/etc/passwd"
        let source = Source.iOS
        
        // When & Then
        XCTAssertThrowsError(try validator.validate(outputPath, for: source, workingDirectory: tempDirectory))
    }
    
    func testDirectoryTraversalWithDoubleSlash() {
        // Given
        let outputPath = "Analytics//../../../etc/passwd"
        let source = Source.iOS
        
        // When & Then
        XCTAssertThrowsError(try validator.validate(outputPath, for: source, workingDirectory: tempDirectory))
    }
    
    func testDirectoryTraversalWithEncodedDoubleDots() {
        // Given
        let outputPath = "Analytics%2F..%2F..%2F..%2Fetc%2Fpasswd"
        let source = Source.iOS
        
        // When & Then
        // This should fail the basic .. check
        XCTAssertThrowsError(try validator.validate(outputPath, for: source, workingDirectory: tempDirectory))
    }
    
    func testDirectoryTraversalWithMixedSeparators() {
        // Given
        let outputPath = "Analytics\\..\\..\\..\\etc\\passwd"
        let source = Source.iOS
        
        // When & Then
        XCTAssertThrowsError(try validator.validate(outputPath, for: source, workingDirectory: tempDirectory))
    }
    
    // MARK: - Edge Cases
    
    func testEmptyPath() {
        // Given
        let outputPath = ""
        let source = Source.iOS
        
        // When & Then
        XCTAssertThrowsError(try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)) { error in
            XCTAssertTrue(error is OutputPathValidationError)
            if case OutputPathValidationError.emptyOutputPath = error {
                // Expected error
            } else {
                XCTFail("Expected emptyOutputPath error")
            }
        }
    }
    
    func testWhitespaceOnlyPath() {
        // Given
        let outputPath = "   "
        let source = Source.iOS
        
        // When & Then
        XCTAssertThrowsError(try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)) { error in
            XCTAssertTrue(error is OutputPathValidationError)
            if case OutputPathValidationError.emptyOutputPath = error {
                // Expected error
            } else {
                XCTFail("Expected emptyOutputPath error")
            }
        }
    }
    
    func testPathWithWhitespace() throws {
        // Given
        let outputPath = "  Events.swift  "
        let source = Source.iOS
        
        // When
        let result = try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)
        
        // Then
        XCTAssertEqual(result, "Events.swift")
    }
    
    // MARK: - Symlink Tests
    
    func testPathWithSymlink() throws {
        // Given
        let symlinkTarget = tempDirectory.appendingPathComponent("target")
        let symlink = tempDirectory.appendingPathComponent("symlink")
        
        // Create a target directory
        try FileManager.default.createDirectory(at: symlinkTarget, withIntermediateDirectories: true)
        
        // Create a symlink
        try FileManager.default.createSymbolicLink(at: symlink, withDestinationURL: symlinkTarget)
        
        let outputPath = "symlink/Events.swift"
        let source = Source.iOS
        
        // When
        let result = try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)
        
        // Then
        XCTAssertEqual(result, "symlink/Events.swift")
    }
    
    func testDirectoryTraversalThroughSymlink() {
        // Given
        let parentDirectory = tempDirectory.deletingLastPathComponent()
        let symlink = tempDirectory.appendingPathComponent("parent")
        
        // Create a symlink pointing to parent directory
        try? FileManager.default.createSymbolicLink(at: symlink, withDestinationURL: parentDirectory)
        
        let outputPath = "parent/../../../etc/passwd"
        let source = Source.iOS
        
        // When & Then
        XCTAssertThrowsError(try validator.validate(outputPath, for: source, workingDirectory: tempDirectory))
    }
    
    // MARK: - File Name Validation Tests
    
    func testInvalidFileName() {
        // Given
        let outputPath = "Events.txt" // Wrong extension for iOS
        let source = Source.iOS
        
        // When & Then
        XCTAssertThrowsError(try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)) { error in
            XCTAssertTrue(error is SwiftFileNameValidationError)
        }
    }
    
    func testValidFileNameWithSpecialCharacters() throws {
        // Given
        let outputPath = "Events+File.swift"
        let source = Source.iOS
        
        // When
        let result = try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)
        
        // Then
        XCTAssertEqual(result, "Events+File.swift")
    }
    
    // MARK: - Path Normalization Tests
    
    func testPathWithSingleDots() throws {
        // Given
        let outputPath = "./Analytics/./Events.swift"
        let source = Source.iOS
        
        // When
        let result = try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)
        
        // Then
        XCTAssertEqual(result, "./Analytics/./Events.swift")
    }
    
    func testPathWithTrailingSlash() throws {
        // Given
        let outputPath = "Analytics/Events.swift/"
        let source = Source.iOS
        
        // When
        let result = try validator.validate(outputPath, for: source, workingDirectory: tempDirectory)
        
        // Then
        // URL.appendingPathComponent normalizes trailing slashes, so this should work
        XCTAssertEqual(result, "Analytics/Events.swift/")
    }
}
