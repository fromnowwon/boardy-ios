import SwiftUI
import Combine

struct RootView: View {
    // 로그인 여부를 앱 스토리지에 저장
    // 앱 재시작 시 자동으로 불러와 로그인 상태 유지
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    // 스플래시 화면 표시 여부
    @State private var showSplash = true
        
    // 토큰 유효 여부 확인용 상태
    @State private var isTokenValid = false
    
    // 뷰가 사라질 때 자동으로 구독 해제
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        NavigationStack {
            if showSplash {
                SplashView(showSplash: $showSplash)
            } else {
                if isLoggedIn {
                    MainView()
                } else {
                    LoginView()
                }
            }
        }
        .task {
            // 앱 시작 후 Task에서 비동기 토큰 검증 수행
            AuthService.shared.validateToken()
                .receive(on: DispatchQueue.main) // UI 업데이트는 메인 스레드에서
                .sink { completion in
                    // 토큰 검증 과정에서 에러 발생 시 로그인 상태 false
                    if case .failure = completion {
                        isLoggedIn = false
                    }
                } receiveValue: { isValid in
                    if isValid {
                        // 토큰 유효하면 로그인 상태 유지
                        isLoggedIn = true
                    } else {
                        // 토큰 만료 또는 유효하지 않으면 Keychain 초기화 후 로그아웃
                        KeychainHelper.standard.clearAll()
                        isLoggedIn = false
                    }
                }
                .store(in: &cancellables) // 구독 저장 → 뷰 사라지면 자동 해제
        }
    }
}

#Preview {
    RootView()
}
