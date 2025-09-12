import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var showSplash = true

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
    }
}

#Preview {
    RootView()
}
