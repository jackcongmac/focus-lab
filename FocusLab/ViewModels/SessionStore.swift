import Foundation
import Combine

final class SessionStore: ObservableObject {
    static let shared = SessionStore()

    @Published private(set) var records: [SessionRecord] = []
    @Published var selectedDuration: SessionDuration = .five
    @Published var enabledThemes: Set<ThemeType> = Set(ThemeType.allCases)

    private let recordsKey  = "fl.sessionRecords"
    private let durationKey = "fl.sessionDuration"
    private let themesKey   = "fl.enabledThemes"

    init() { load() }

    // MARK: - Write

    func add(_ record: SessionRecord) {
        records.insert(record, at: 0)
        persistRecords()
    }

    func setDuration(_ d: SessionDuration) {
        selectedDuration = d
        UserDefaults.standard.set(d.rawValue, forKey: durationKey)
    }

    func toggleTheme(_ theme: ThemeType) {
        // Keep at least one theme enabled
        if enabledThemes.contains(theme), enabledThemes.count == 1 { return }
        if enabledThemes.contains(theme) {
            enabledThemes.remove(theme)
        } else {
            enabledThemes.insert(theme)
        }
        persistThemes()
    }

    // MARK: - Today stats

    var todaySessions: [SessionRecord] {
        records.filter { Calendar.current.isDateInToday($0.date) }
    }

    var todayTotalSeconds: TimeInterval {
        todaySessions.reduce(0) { $0 + $1.secondsPlayed }
    }

    // MARK: - Persistence

    private func load() {
        if let data = UserDefaults.standard.data(forKey: recordsKey),
           let decoded = try? JSONDecoder().decode([SessionRecord].self, from: data) {
            records = decoded
        }
        let rawDuration = UserDefaults.standard.integer(forKey: durationKey)
        if let d = SessionDuration(rawValue: rawDuration), rawDuration > 0 {
            selectedDuration = d
        }
        if let rawThemes = UserDefaults.standard.stringArray(forKey: themesKey) {
            let decoded = Set(rawThemes.compactMap { ThemeType(rawValue: $0) })
            if !decoded.isEmpty { enabledThemes = decoded }
        }
    }

    private func persistRecords() {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: recordsKey)
        }
    }

    private func persistThemes() {
        UserDefaults.standard.set(enabledThemes.map(\.rawValue), forKey: themesKey)
    }
}
