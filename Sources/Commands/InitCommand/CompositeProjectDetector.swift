import Foundation

struct CompositeProjectDetector: ProjectDetector {
    private let projectDetectors: [ProjectDetector]

    init(projectDetectors: [ProjectDetector]) {
        self.projectDetectors = projectDetectors
    }

    func detectProject(in directory: URL) -> ProjectDirectory? {
        for supportedProject in projectDetectors {
            if let project = supportedProject.detectProject(in: directory) {
                return project
            }
        }
        return nil
    }
}
