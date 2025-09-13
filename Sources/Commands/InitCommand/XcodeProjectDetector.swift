import Foundation

struct XcodeProjectDetector: ProjectDetector {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func detectProject(in directory: URL) -> ProjectInfo? {
        guard let projectName = findProjectName(in: directory) else { return nil }
        return ProjectInfo(
            name: projectName,
            source: Source.iOS,
            plugin: .swiftgen(.default)
        )
    }

    private func findProjectName(in directory: URL) -> String? {
        guard let contents = try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil).map(\.relativePath) else {
            return nil
        }

        let xcodeProjects = contents.filter { $0.hasSuffix(".xcodeproj") }
        guard let projectPath = xcodeProjects.first else {
            return nil
        }

        return (projectPath as NSString).deletingPathExtension
    }
}
