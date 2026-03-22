import SwiftUI

struct SessionSummaryView: View {
    let record: SessionRecord
    let onPracticeAgain: () -> Void

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.indigo.opacity(0.70))

                    Text("Session Complete")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.primary)

                    Text("Great practice today.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 64)
                .padding(.bottom, 36)

                // Stats card
                statsCard
                    .padding(.horizontal, 28)
                    .padding(.bottom, 28)

                // Skills practiced
                skillsCard
                    .padding(.horizontal, 28)

                Spacer()

                // Action
                Button(action: onPracticeAgain) {
                    Text("Practice Again")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.indigo.opacity(0.80), in: RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
    }

    // MARK: - Stats

    private var statsCard: some View {
        VStack(spacing: 0) {
            statRow(label: "Time practiced", value: durationText)
            Divider().padding(.leading, 16)
            statRow(label: "Levels completed", value: "\(record.levelsCompleted)")
            Divider().padding(.leading, 16)
            statRow(label: "Accuracy", value: accuracyText)
        }
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 14))
    }

    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
    }

    private var durationText: String {
        let m = record.selectedMinutes
        return "\(m) min"
    }

    private var accuracyText: String {
        guard record.totalTaps > 0 else { return "—" }
        return "\(Int(record.accuracy * 100))%"
    }

    // MARK: - Skills

    private var skillsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your child practiced:")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
                .padding(.bottom, 2)

            ForEach(practiceSkills, id: \.self) { skill in
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Circle()
                        .fill(Color.indigo.opacity(0.40))
                        .frame(width: 5, height: 5)
                        .padding(.top, 1)
                    Text(skill)
                        .font(.subheadline)
                        .foregroundStyle(Color.primary.opacity(0.85))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 14))
    }

    private var practiceSkills: [String] {
        var skills: [String] = []

        // One theme-specific skill per theme practiced (in order visited)
        for theme in record.themes {
            switch theme {
            case "Shapes":
                skills.append("Identifying shapes by color and name")
            case "Animals":
                skills.append("Sorting objects by category")
            case "Vehicles":
                skills.append("Recognizing objects by color and type")
            default:
                break
            }
        }

        // Universal skills that apply to every session
        skills.append("Following multi-step instructions")
        skills.append("Holding a sequence in working memory")

        return Array(skills.prefix(3))
    }
}
