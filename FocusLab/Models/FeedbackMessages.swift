import Foundation

enum FeedbackMessages {

    // Shown on correct mid-level tap
    static let correct: [String] = [
        "Good", "Yes", "There it is", "Got it", "Nice one"
    ]

    // Shown on wrong tap
    static let error: [String] = [
        "Try again", "No rush", "Almost", "Give it a go"
    ]

    // Shown on level completion (toast overlay)
    static let completion: [String] = [
        "Well done", "Nice", "Great focus", "All done"
    ]

    // Defined for future use — not wired up in MVP
    static let next: [String] = [
        "Now", "Next up", "Keep going"
    ]

    /// Returns a random entry from `pool`, avoiding the previous pick where possible.
    static func pick(from pool: [String], avoiding last: String?) -> String {
        let candidates = pool.count > 1 ? pool.filter { $0 != last } : pool
        return candidates.randomElement() ?? pool[0]
    }
}
