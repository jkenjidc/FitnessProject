import SwiftUI

struct CapsuleStyle: ViewModifier {
    let backgroundColor: Color
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat

    init(
        backgroundColor: Color,
        horizontalPadding: CGFloat,
        verticalPadding: CGFloat
    ) {
        self.backgroundColor = backgroundColor
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }

    func body(content: Content) -> some View {
        content
            .fontWeight(.medium)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(backgroundColor)
            .clipShape(Capsule())
    }
}

extension View {
    func capsuleStyle(
        backgroundColor: Color = .secondary,
        horizontalPadding: CGFloat = 12,
        verticalPadding: CGFloat = 6
    ) -> some View {
        modifier(CapsuleStyle(
            backgroundColor: backgroundColor,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding
        ))
    }
}
