import SwiftUI
import Combine

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
   
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("이메일", text: $email)
                .font(.system(size: 16))
                .padding(.vertical, 14)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            SecureField("비밀번호", text: $password)
                .font(.system(size: 16))
                .padding(.vertical, 14)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }

            
            Button("로그인") {
                print("이메일:", email, "비밀번호:", password)
                login()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func login() {
        errorMessage = nil
        
        cancellable = LoginService.shared.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { loginResponse in
                // accessToken, refreshToken 등을 받아서 앱에 저장 가능
                self.isLoggedIn = true
                print("Access Token:", loginResponse.accessToken)
            })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
