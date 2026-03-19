import SwiftUI

struct SuccessView: View {
    let isLastLevel: Bool
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
                Text(isLastLevel ? "Session Complete!" : "Nice work!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary.opacity(0.85))

                Text(isLastLevel ? "You did great!" : "Keep it up!")
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            Button(action: onNext) {
                Text(isLastLevel ? "Start Over" : "Next")
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
