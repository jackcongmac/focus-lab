import SwiftUI

// MARK: - Feedback State

enum ItemFeedback: Equatable {
    case idle
    case correct
    case error
}

// MARK: - PlayItemButton

struct PlayItemButton: View {
    let item: PlayItem
    let feedback: ItemFeedback
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)

                // Feedback border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderColor, lineWidth: 2.5)

                itemShape
                    .frame(width: 64, height: 64)
                    .opacity(feedback == .error ? 0.35 : 1.0)
            }
            .aspectRatio(1, contentMode: .fit)
        }
        .buttonStyle(PressScaleButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: feedback)
    }

    private var borderColor: Color {
        switch feedback {
        case .idle:    return .clear
        case .correct: return Color.green.opacity(0.65)
        case .error:   return Color.red.opacity(0.55)
        }
    }

    @ViewBuilder
    private var itemShape: some View {
        switch item.shape {
        case .circle:
            Circle()
                .fill(item.color)
        case .square:
            RoundedRectangle(cornerRadius: 10)
                .fill(item.color)
        case .triangle:
            TriangleShape()
                .fill(item.color)
        case .star:
            StarShape()
                .fill(item.color)
        }
    }
}

// MARK: - Press Scale Button Style (Spec 4.1)

private struct PressScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(
                configuration.isPressed
                    ? .easeIn(duration: 0.08)
                    : .easeOut(duration: 0.12),
                value: configuration.isPressed
            )
    }
}

// MARK: - Custom Shapes

private struct TriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct StarShape: Shape {
    private let pointCount = 5

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outerR = min(rect.width, rect.height) / 2
        let innerR = outerR * 0.42
        var path   = Path()

        for i in 0 ..< pointCount * 2 {
            let angle = (Double(i) * .pi / Double(pointCount)) - (.pi / 2)
            let r     = i.isMultiple(of: 2) ? outerR : innerR
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * r,
                y: center.y + CGFloat(sin(angle)) * r
            )
            i == 0 ? path.move(to: point) : path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}
