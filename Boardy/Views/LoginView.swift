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
            Spacer()
            
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

            
            Button(action: {
                print("이메일:", email, "비밀번호:", password)
                login()
            }) {
                Text("로그인")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .contentShape(Rectangle())
            
            HStack {
                Text("아직 회원이 아니신가요?")
                    .foregroundColor(.gray)
                
                NavigationLink(destination: SignUpView()) {
                    Text("회원가입")
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("로그인")
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

#Preview {
    LoginView()
}
