import Foundation

struct XcodeProjectDetector: ProjectDetector {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func detectProject(in directory: URL) -> ProjectDirectory? {
        guard let projectName = findProjectName(in: directory) else { return nil }
        return ProjectDirectory(
            name: projectName,
            source: .iOS
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
