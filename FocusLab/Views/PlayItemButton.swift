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
    let isHinted: Bool
    let action: () -> Void

    @State private var shakeOffset: CGFloat = 0
    @State private var flashOpacity: CGFloat = 0
    @State private var hintPulse: Bool = false

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)

                // Correct-tap highlight (soft green wash, fades with existing animation)
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.green.opacity(feedback == .correct ? 0.12 : 0))

                // Feedback border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(borderColor, lineWidth: feedback == .correct ? 3.5 : 2.5)

                // Hint ring — pulsing amber glow when player is idle > 4 s
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.orange.opacity(hintPulse ? 0.60 : 0.20), lineWidth: 3)
                    .opacity(isHinted && feedback == .idle ? 1 : 0)

                // Icon — crossfades when item changes between levels
                itemShape
                    .frame(width: iconSize, height: iconSize)
                    .opacity(feedback == .error ? 0.35 : 1.0)
                    .id(item.id)
                    .transition(.opacity.combined(with: .scale(scale: 0.82)))

                // Brief white flash on correct tap
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(flashOpacity))
                    .allowsHitTesting(false)
            }
            .aspectRatio(1, contentMode: .fit)
            .animation(.easeInOut(duration: 0.2), value: item.id)
        }
        .buttonStyle(PressScaleButtonStyle())
        .scaleEffect(feedback == .correct ? 1.12 : 1.0)
        .shadow(color: Color.green.opacity(feedback == .correct ? 0.35 : 0), radius: 12)
        .offset(x: shakeOffset)
        .animation(.spring(response: 0.25, dampingFraction: 0.55), value: feedback)
        .onChange(of: feedback) { newVal in
            if newVal == .correct {
                // TODO: SoundManager.play(.correct)
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation(.easeOut(duration: 0.08)) { flashOpacity = 0.13 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    withAnimation(.easeIn(duration: 0.1)) { flashOpacity = 0 }
                }
            }
            guard newVal == .error else { return }
            withAnimation(.easeInOut(duration: 0.05).repeatCount(5, autoreverses: true)) {
                shakeOffset = 5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                shakeOffset = 0
            }
        }
        .onChange(of: isHinted) { hinted in
            if hinted {
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                    hintPulse = true
                }
            } else {
                withAnimation(.linear(duration: 0.15)) { hintPulse = false }
            }
        }
    }

    /// Per-shape optical size compensation so all icons feel equally weighted.
    /// Circle and square fill their bounding box fully; triangle and star have low
    /// effective fill and need a larger frame to read as the same visual mass.
    private var iconSize: CGFloat {
        switch item.content {
        case .shape(let s):
            switch s {
            case .circle:   return 58   // full disk — smallest to balance
            case .square:   return 56   // near-full fill (rounded corners)
            case .triangle: return 70   // ~50 % fill — needs clear upsize
            case .star:     return 78   // thin points, lowest fill — largest frame
            case .pentagon: return 64
            case .oval:     return 64   // height capped inside shapeView
            case .diamond:  return 62
            case .hexagon:  return 64
            }
        case .sfSymbol, .asset:
            return 62
        }
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
        switch item.content {
        case .shape(let s):
            shapeView(s)
        case .sfSymbol(let name, _):
            Image(systemName: name)
                .resizable()
                .scaledToFit()
                .foregroundColor(item.color)
        case .asset(let name, _):
            Image(name)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(item.color)
        }
    }

    @ViewBuilder
    private func shapeView(_ s: ItemShape) -> some View {
        switch s {
        case .circle:
            Circle().fill(item.color)
        case .square:
            RoundedRectangle(cornerRadius: 10).fill(item.color)
        case .triangle:
            TriangleShape().fill(item.color)
        case .star:
            StarShape().fill(item.color)
        case .pentagon:
            PolygonShape(sides: 5).fill(item.color)
        case .oval:
            Ellipse().fill(item.color).frame(width: iconSize, height: iconSize * 0.62)
        case .diamond:
            DiamondShape().fill(item.color)
        case .hexagon:
            PolygonShape(sides: 6).fill(item.color)
        }
    }
}

// MARK: - Press Scale Button Style (Spec 4.1)

private struct PressScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
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

/// Regular n-sided polygon with a vertex at the top.
private struct PolygonShape: Shape {
    let sides: Int

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let r      = min(rect.width, rect.height) / 2
        var path   = Path()

        for i in 0 ..< sides {
            let angle = (Double(i) * 2 * .pi / Double(sides)) - (.pi / 2)
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

/// Four-point rhombus (diamond) aligned to the bounding rect midpoints.
private struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to:    CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}
