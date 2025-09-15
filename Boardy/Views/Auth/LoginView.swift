import SwiftUI
import Combine

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    @State private var cancellables = Set<AnyCancellable>()
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
        
        LoginService.shared.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if let apiError = error as? ErrorResponse {
                        errorMessage = apiError.message
                    } else {
                        errorMessage = error.localizedDescription
                    }
                case .finished:
                    break
                }
            } receiveValue: {
                isLoggedIn = true
            }
            .store(in: &cancellables)
    }
}

#Preview {
    LoginView()
}
