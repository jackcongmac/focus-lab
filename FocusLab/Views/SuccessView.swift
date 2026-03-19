import SwiftUI

struct SuccessView: View {
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            ZStack {
                Circle()
                    .fill(Color.indigo.opacity(0.08))
                    .frame(width: 120, height: 120)

                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(Color.indigo.opacity(0.75))
            }

            VStack(spacing: 8) {
                Text("Mission Complete")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary.opacity(0.85))

                Text("Great focus!")
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Button(action: onNext) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 160, height: 50)
                    .background(
                        Capsule()
                            .fill(Color.indigo.opacity(0.80))
                    )
            }
            .buttonStyle(.plain)
        }
    }
}
