import SwiftUI

struct SplashView: View {
    // 스플래시 화면에서 MainView로 전환하기 위한 상태
    @State private var isActive = false
    @State private var opacity = 0.0
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                Text("Boardy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(opacity)
            }
        }
        .onAppear {
            // 뷰가 나타날 때
            withAnimation(.easeIn(duration: 1.5)) {
                opacity = 1.0
            }
            
            // 2초 후 화면 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isActive = true
            }
        }
        
        // 로그인 상태에 따라 다음 화면 결정
        .fullScreenCover(isPresented: $isActive) {
            if isLoggedIn {
                MainView()
            } else {
                OnboardingView()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
