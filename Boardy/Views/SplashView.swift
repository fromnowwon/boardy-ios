import SwiftUI

struct SplashView: View {
    // 스플래시 화면에서 MainView로 전환하기 위한 상태
    @State private var isActive = false
    @State private var opacity = 0.0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // 배경 흰색, 안전 영역까지 확장
            
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
            
            // 2초 후 자동으로 MainView로 이동
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isActive = true
            }
        }
        
        // isActive가 true면 MainView로 전환
        .fullScreenCover(isPresented: $isActive) {
            MainView() // SplashView 종료 후 보여줄 화면
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
