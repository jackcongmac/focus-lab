import SwiftUI

struct CalmOrbView: View {
    let isActive: Bool
    let isSuccess: Bool

    @State private var breatheScale: CGFloat = 0.98
    @State private var activeScale:  CGFloat = 1.0
    @State private var orbOpacity:   Double  = 0.85

    // Soft blue-centre → indigo-edge radial gradient
    private let gradient = RadialGradient(
        colors: [
            Color(red: 0.65, green: 0.75, blue: 0.98),
            Color(red: 0.40, green: 0.35, blue: 0.80)
        ],
        center: .center,
        startRadius: 0,
        endRadius: 9          // half of 18 pt diameter
    )

    var body: some View {
        ZStack {
            Circle()
                .fill(gradient)
                .frame(width: 18, height: 18)

            // Eyes — two static dots, slightly darker than the orb surface
            HStack(spacing: 4) {
                Circle().fill(Color(red: 0.30, green: 0.28, blue: 0.65).opacity(0.75))
                    .frame(width: 1.5, height: 1.5)
                Circle().fill(Color(red: 0.30, green: 0.28, blue: 0.65).opacity(0.75))
                    .frame(width: 1.5, height: 1.5)
            }
            .offset(y: -1.5)
        }
        .scaleEffect(breatheScale * activeScale)
        .opacity(orbOpacity)
            .onAppear {
                // Idle breathing — runs forever in the background
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                ) {
                    breatheScale = 1.02
                }
            }
            .onChange(of: isActive) { active in
                guard active else { return }
                // Brief delight spike on correct tap
                withAnimation(.easeOut(duration: 0.15)) {
                    activeScale = 1.08
                    orbOpacity  = 0.95
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeIn(duration: 0.2)) {
                        activeScale = 1.0
                        orbOpacity  = 0.85
                    }
                }
            }
            .onChange(of: isSuccess) { success in
                if success {
                    // Sustained bloom during level success
                    withAnimation(.easeOut(duration: 0.25)) {
                        activeScale = 1.14
                        orbOpacity  = 1.0
                    }
                } else {
                    withAnimation(.easeIn(duration: 0.3)) {
                        activeScale = 1.0
                        orbOpacity  = 0.85
                    }
                }
            }
    }
}
