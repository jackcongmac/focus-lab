import SwiftUI

struct ParentView: View {
    @ObservedObject var store: SessionStore
    /// Theme that must stay ON during an active/paused session. Nil when idle.
    var lockedTheme: ThemeType? = nil

    @State private var showLengthAlert = false

    /// True when a session is currently active or paused.
    private var sessionInProgress: Bool { lockedTheme != nil }

    var body: some View {
        NavigationView {
            List {
                todaySection
                settingsSection
                historySection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Parent Area")
            .navigationBarTitleDisplayMode(.inline)
        }
        .overlay {
            if showLengthAlert {
                ZStack {
                    Color.black.opacity(0.35)
                        .ignoresSafeArea()
                        .onTapGesture { showLengthAlert = false }
                    VStack(spacing: 12) {
                        Text("Session length will update next time")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        Text("This change will apply at the start of the next session. To use it now, return to Home and tap Restart.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Divider()
                            .padding(.top, 4)
                        Button("OK") { showLengthAlert = false }
                            .font(.body.weight(.semibold))
                    }
                    .padding(24)
                    .background(.background, in: RoundedRectangle(cornerRadius: 14))
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
                    .padding(.horizontal, 40)
                }
            }
        }
    }

    // MARK: - Today

    private var todaySection: some View {
        Section {
            HStack {
                summaryTile(
                    value: "\(store.todaySessions.count)",
                    label: "sessions"
                )
                Divider().frame(height: 36)
                summaryTile(
                    value: todayTimeText,
                    label: "practiced"
                )
            }
            .padding(.vertical, 4)
        } header: {
            Text("Today")
        }
    }

    private func summaryTile(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color.indigo.opacity(0.85))
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var todayTimeText: String {
        let total = Int(store.todayTotalSeconds)
        let m = total / 60
        let s = total % 60
        if m == 0 { return "\(s)s" }
        if s == 0 { return "\(m)m" }
        return "\(m)m \(s)s"
    }

    // MARK: - Settings

    private var settingsSection: some View {
        Section {
            // Duration picker
            VStack(alignment: .leading, spacing: 10) {
                Text("Session length")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    ForEach(SessionDuration.allCases, id: \.self) { d in
                        Button {
                            store.setDuration(d)
                            if sessionInProgress { showLengthAlert = true }
                        } label: {
                            Text(d.label)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    store.selectedDuration == d
                                        ? Color.indigo.opacity(0.15)
                                        : Color(.tertiarySystemFill),
                                    in: Capsule()
                                )
                                .foregroundStyle(
                                    store.selectedDuration == d
                                        ? Color.indigo
                                        : Color.primary.opacity(0.70)
                                )
                                .overlay(
                                    Capsule().stroke(
                                        store.selectedDuration == d
                                            ? Color.indigo.opacity(0.40)
                                            : Color.clear,
                                        lineWidth: 1
                                    )
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.vertical, 4)

            // Theme toggles
            VStack(alignment: .leading, spacing: 10) {
                Text("Content themes")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ForEach(ThemeType.allCases, id: \.self) { theme in
                    let isLocked = theme == lockedTheme
                    HStack {
                        Text(theme.displayName)
                            .font(.body)
                            .foregroundStyle(isLocked ? .secondary : .primary)
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { store.enabledThemes.contains(theme) },
                            set: { _ in store.toggleTheme(theme) }
                        ))
                        .labelsHidden()
                        .tint(Color.indigo.opacity(0.75))
                        .disabled(isLocked)
                    }
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("Settings")
        } footer: {
            Text("Changes take effect at the start of the next session.")
                .font(.caption)
        }
    }

    // MARK: - History

    private var historySection: some View {
        Section {
            if store.records.isEmpty {
                Text("No sessions yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            } else {
                ForEach(store.records.prefix(20)) { record in
                    historyRow(record)
                }
            }
        } header: {
            Text("Session History")
        }
    }

    private func historyRow(_ record: SessionRecord) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(record.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                HStack(spacing: 6) {
                    Text(record.themes.joined(separator: " · "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("\(record.selectedMinutes) min")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.indigo.opacity(0.80))
                if record.totalTaps > 0 {
                    Text("\(Int(record.accuracy * 100))% accuracy")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
}
