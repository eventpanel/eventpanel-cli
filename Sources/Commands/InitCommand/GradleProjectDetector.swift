import Foundation

struct GradleProjectDetector: ProjectDetector {
    private let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    func detectProject(in directory: URL) -> ProjectInfo? {
        guard let projectName = findProjectName(in: directory) else { return nil }
        return ProjectInfo(
            name: projectName,
            source: Source.android,
            plugin: .kotlingen(.default)
        )
    }

    private func findProjectName(in directory: URL) -> String? {
        guard let contents = try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil).map(\.relativePath) else {
            return nil
        }

        // Check for typical Android project files
        let hasBuildGradle = contents.contains { $0 == "build.gradle" || $0 == "build.gradle.kts" }
        let hasSettingsGradle = contents.contains { $0 == "settings.gradle" || $0 == "settings.gradle.kts" }
        let hasGradleWrapper = contents.contains { $0 == "gradlew" }

        if hasBuildGradle && (hasSettingsGradle || hasGradleWrapper) {
            // Use the directory name as the project name
            return directory.lastPathComponent
        }

        return nil
    }
}
