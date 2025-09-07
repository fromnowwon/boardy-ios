import SwiftUI

struct OnboardingView: View {
    @State private var showLogin = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Boardy에 오신 것을 환영합니다.")
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            Button(action: {
                showLogin = true
            }) {
                Text("Boardy 시작하기")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
        
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
