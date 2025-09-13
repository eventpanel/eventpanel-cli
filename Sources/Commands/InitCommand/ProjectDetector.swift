import Foundation

protocol ProjectDetector {
    func detectProject(in directory: URL) -> ProjectInfo?
}
