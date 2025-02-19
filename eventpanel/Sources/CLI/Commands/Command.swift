import Foundation

protocol Command {
    var name: String { get }
    var description: String { get }
    func execute(with arguments: [String]) throws
} 