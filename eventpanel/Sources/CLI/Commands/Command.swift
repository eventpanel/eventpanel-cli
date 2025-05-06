import Foundation

protocol Command {
    func execute(with arguments: [String]) async throws
} 
