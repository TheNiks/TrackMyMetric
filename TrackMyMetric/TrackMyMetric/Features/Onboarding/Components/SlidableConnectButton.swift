import SwiftUI

struct SlidableConnectButton: View {
    @Binding var resetTrigger: Bool
    @State private var offset: CGFloat = 0
    @State private var isComplete = false
    @State private var rippleScale: CGFloat = 1.0
    @State private var rippleOpacity: Double = 0.5
    
    let onSwipeSuccess: () -> Void
    
    private let buttonWidth: CGFloat = 340
    private let buttonHeight: CGFloat = 74
    private let handleSize: CGFloat = 58
    
    var body: some View {
        ZStack {
            // 1. The Main Track (Gradient from your SS)
            Capsule()
                .fill(AppTheme.primaryButton)
                .frame(width: buttonWidth, height: buttonHeight)
            
            // 2. The Center Text
            Text("Connect Health")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .offset(x: 20) // Nudge right to account for the handle
                .opacity(1.0 - Double(offset / 150)) // Fade out as we slide
            
            // 3. The Slidable Handle with Ripple
            HStack {
                ZStack {
                    // The "Play Ripple" Shapes (Layered circles)
                    Circle() // Outer glow/ripple
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 85, height: 85)
                        .scaleEffect(rippleScale)
                        .opacity(rippleOpacity)
                    
                    Circle() // Inner glass layer
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 65, height: 65)
                    
                    // The Play Icon
                    Image(systemName: "play.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
                .offset(x: offset - 5) // Slightly overhang to the left like the SS
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            let dragLimit = buttonWidth - handleSize - 20
                            if gesture.translation.width > 0 && offset <= dragLimit {
                                offset = gesture.translation.width
                            }
                        }
                        .onEnded { _ in
                            if offset > (buttonWidth * 0.6) {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    offset = buttonWidth - handleSize - 20
                                }
                                onSwipeSuccess()
                            } else {
                                withAnimation(.spring()) {
                                    offset = 0
                                }
                            }
                        }
                )
                Spacer()
            }
        }
        .frame(width: buttonWidth, height: 100) // Extra height for the ripple overflow
        .onAppear {
            // Start the breathing ripple animation
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                rippleScale = 1.1
                rippleOpacity = 0.3
            }
        }
        .onChange(of: resetTrigger) {
            resetPosition()
        }
    }
    
    private func resetPosition() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            offset = 0
        }
    }
}
