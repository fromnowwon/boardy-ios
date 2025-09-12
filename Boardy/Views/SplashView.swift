import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool
    @State private var opacity = 0.0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Text("Boardy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.5)) {
                opacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSplash = false
            }
        }
    }
}

#Preview {
    SplashView(showSplash: .constant(true))
}
