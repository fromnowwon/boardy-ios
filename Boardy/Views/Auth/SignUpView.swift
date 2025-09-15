import SwiftUI
import Combine

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var nickname = ""
    @State private var errorMessage: String?
    @State private var successMessage: String?

    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack(spacing: 20) {
            // 이메일 입력
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
            
            // 비밀번호 입력
            SecureField("비밀번호", text: $password)
                .font(.system(size: 16))
                .padding(.vertical, 14)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            // 비밀번호 확인
            SecureField("비밀번호 확인", text: $confirmPassword)
                .font(.system(size: 16))
                .padding(.vertical, 14)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
            // 닉네임 입력
            TextField("닉네임", text: $nickname)
                .font(.system(size: 16))
                .padding(.vertical, 14)
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            // 에러 메시지
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // 성공 메시지
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .font(.caption)
            }
            
            // 회원가입 버튼
            Button(action: {
               signUp()
            }) {
                Text("회원가입")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("회원가입")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func signUp() {
        // 기본 유효성 검사
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !nickname.isEmpty else {
            errorMessage = "모든 필드를 입력해주세요."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "비밀번호가 일치하지 않습니다."
            return
        }
        
        guard isValidEmail(email) else {
            errorMessage = "유효한 이메일을 입력해주세요."
            return
        }
        
        errorMessage = nil
        successMessage = nil

        // API 요청
        cancellable = SignUpService.shared.signUp(email: email, password: password, nickname: nickname)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                self.successMessage = "회원가입 성공! 로그인 해주세요."
                
                // 성공 시 로그인 화면으로 돌아가기
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
            })
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
