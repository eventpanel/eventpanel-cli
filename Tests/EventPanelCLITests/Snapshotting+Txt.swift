import Foundation
import XCTest
import SnapshotTesting

extension Snapshotting where Value == String, Format == String {
    static var txt: Snapshotting {
        var snapshotting = SimplySnapshotting.lines
        snapshotting.pathExtension = "txt"
        return snapshotting
    }
}
