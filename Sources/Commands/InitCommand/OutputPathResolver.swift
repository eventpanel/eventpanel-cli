import Foundation

protocol OutputPathResolver {
    func resolvePath(
        input: String?,
        defaultFileName: String,
        workingDirectory: URL
    ) throws -> URL
}

final class GeneratorOutputFilePathResolver: OutputPathResolver {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func resolvePath(
        input: String?,
        defaultFileName: String,
        workingDirectory: URL
    ) throws -> URL {
        let relativePath = input?.isEmpty == false ? input! : defaultFileName

        let fileURL = URL(fileURLWithPath: relativePath, relativeTo: workingDirectory)
            .standardizedFileURL

        guard fileURL.path.hasPrefix(workingDirectory.path) else {
            throw InitCommandError.notNestedPath(fileURL)
        }

        // Determine if the URL points to a directory or file
        var isDirectory: ObjCBool = false
        let pathExists = fileManager.fileExists(atPath: fileURL.path, isDirectory: &isDirectory)
        
        let dirURL: URL
        if pathExists && isDirectory.boolValue {
            // The URL points to an existing directory
            dirURL = fileURL
        } else {
            // The URL points to a file or doesn't exist yet, get its parent directory
            dirURL = fileURL.deletingLastPathComponent()
        }

        if !fileManager.fileExists(atPath: dirURL.path) {
            do {
                try fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                throw InitCommandError.invalidPath(dirURL)
            }
        }

        return fileURL
    }
}
