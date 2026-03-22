import Foundation

struct SessionRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let selectedMinutes: Int
    let secondsPlayed: TimeInterval
    let levelsCompleted: Int
    let correctTaps: Int
    let totalTaps: Int
    let themes: [String]   // ThemeType.displayName values practiced this session

    var accuracy: Double {
        totalTaps == 0 ? 1.0 : Double(correctTaps) / Double(totalTaps)
    }
}
