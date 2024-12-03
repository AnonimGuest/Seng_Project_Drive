import ActivityKit
import Foundation

struct TimeTrackingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var startTime: Date
    }
}
