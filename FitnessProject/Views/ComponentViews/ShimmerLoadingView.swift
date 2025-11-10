import SwiftUI

struct ShimmerLoadingView: View {
    @State private var animationOffset: CGFloat = -300

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(0..<12, id: \.self) { index in
                    HStack(spacing: 12) {
                        ShimmerRectangle(
                            animationOffset: animationOffset,
                            height: 50,
                            cornerRadius: 8
                        )
                        .frame(width: 50)

                        VStack(alignment: .leading, spacing: 8) {
                            // Title placeholder
                            ShimmerRectangle(
                                animationOffset: animationOffset,
                                height: 16,
                                cornerRadius: 4
                            )

                            // Subtitle placeholder
                            ShimmerRectangle(
                                animationOffset: animationOffset,
                                height: 12,
                                cornerRadius: 4
                            )
                            .frame(width: 120)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .opacity(opacityForIndex(index))
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            startShimmerAnimation()
        }
    }

    private func opacityForIndex(_ index: Int) -> Double {
        let middleIndex = 6.0
        let distance = abs(Double(index) - middleIndex)
        let opacity = 1.0 - (distance / middleIndex) * 0.7
        return max(opacity, 0.3)
    }

    private func startShimmerAnimation() {
        withAnimation(
            .linear(duration: 1.8)
            .repeatForever(autoreverses: false)
        ) {
            animationOffset = 300
        }
    }
}

struct ShimmerRectangle: View {
    let animationOffset: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat

    init(
        animationOffset: CGFloat,
        height: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.animationOffset = animationOffset
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.15))
            .frame(height: height)
            .cornerRadius(cornerRadius)
            .overlay(
                // Softer shimmer gradient with more transition points
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.clear,
                        Color.clear,
                        Color.clear,
                        Color.clear,
                        Color.white.opacity(0.03),
                        Color.white.opacity(0.06),
                        Color.white.opacity(0.09),
                        Color.white.opacity(0.12),
                        Color.white.opacity(0.15),
                        Color.white.opacity(0.18),
                        Color.white.opacity(0.2),
                        Color.white.opacity(0.18),
                        Color.white.opacity(0.15),
                        Color.white.opacity(0.12),
                        Color.white.opacity(0.09),
                        Color.white.opacity(0.06),
                        Color.white.opacity(0.03),
                        Color.clear,
                        Color.clear,
                        Color.clear,
                        Color.clear,
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .blur(radius: 2.5) // Adds softness to edges
                    .rotationEffect(.degrees(8))
                    .offset(x: animationOffset)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
