import Foundation

protocol OutputPathValidator {
    func validate(_ outputPath: String, for source: Source, workingDirectory: URL) throws -> String
}

final class DefaultOutputPathValidator: OutputPathValidator {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func validate(
        _ outputPath: String,
        for source: Source,
        workingDirectory: URL
    ) throws -> String {
        // Check if output path is empty
        guard !outputPath.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw OutputPathValidationError.emptyOutputPath
        }
        
        let trimmedPath = outputPath.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Create the full URL by combining working directory with the output path
        let fullURL = workingDirectory.appendingPathComponent(trimmedPath)
        
        // Validate that the path is nested within the working directory
        guard fullURL.path.hasPrefix(workingDirectory.path) else {
            throw OutputPathValidationError.notNestedPath(workingDirectory)
        }
        
        // Extract the file name from the path
        let fileName = fullURL.lastPathComponent
        
        // Validate the file name based on the source platform
        try validateFileName(fileName, for: source)
        
        // Create the directory path (parent directory of the file)
        let directoryURL = fullURL.deletingLastPathComponent()
        
        // Check if the directory can be created or already exists
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw OutputPathValidationError.invalidPath(directoryURL)
        }
        
        // Return the validated path
        return trimmedPath
    }
    
    private func validateFileName(_ fileName: String, for source: Source) throws {
        switch source {
        case .iOS:
            return try SwiftFileNameValidator.validate(fileName)
        case .android:
            return try KotlinFileNameValidator.validate(fileName)
        }
    }
}

enum OutputPathValidationError: LocalizedError {
    case emptyOutputPath
    case notNestedPath(URL)
    case invalidPath(URL)
    
    var errorDescription: String? {
        switch self {
        case .emptyOutputPath:
            return "Output path cannot be empty"
        case .notNestedPath(let url):
            return "The file must be inside the workspace directory \(url.path)"
        case .invalidPath(let url):
            return "Cannot create directory at \(url.path)"
        }
    }
}

extension URL {
    /// Returns the relative path from a base URL
    func relativePath(from baseURL: URL) -> String {
        let basePath = baseURL.path
        let currentPath = self.path
        
        if currentPath.hasPrefix(basePath) {
            let relativePath = String(currentPath.dropFirst(basePath.count))
            return relativePath.hasPrefix("/") ? String(relativePath.dropFirst()) : relativePath
        }
        
        return currentPath
    }
}
