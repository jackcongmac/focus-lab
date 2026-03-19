import SwiftUI

struct InstructionsView: View {
    let steps: [MissionStep]

    var body: some View {
        VStack(spacing: 28) {
            Text("Your Mission")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .tracking(1.5)

            VStack(alignment: .leading, spacing: 18) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .center, spacing: 14) {
                        Text("\(index + 1)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(Color.indigo.opacity(0.75)))

                        Text(step.instruction)
                            .font(.body)
                            .foregroundColor(.primary.opacity(0.80))
                    }
                }
            }
            .padding(22)
            .frame(maxWidth: 380)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.secondarySystemBackground))
            )
        }
    }
}
