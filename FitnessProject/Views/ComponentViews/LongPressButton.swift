import SwiftUI

struct LongPressButton: View {
    @GestureState private var isPressed = false
    let duration: Double = 1.0

    let onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.red.opacity(0.7))
                .cornerRadius(20)
            
            Rectangle()
                .fill(Color.red)
                .cornerRadius(20)
                .scaleEffect(x: isPressed ? 1 : 0, y: 1, anchor: .leading)
                .animation(.linear(duration: duration), value: isPressed)
                .clipShape(.rect(cornerRadius: 20))
            
            Text("Delete")
                .foregroundColor(.white)
                .padding()
        }
        .gesture(
            LongPressGesture(minimumDuration: duration)
                .updating($isPressed) { currentState, gestureState, _ in
                    gestureState = currentState
                }
                .onEnded { _ in
                    onDelete()
                }
        )
    }
}
