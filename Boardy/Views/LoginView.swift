import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var email = ""
    @State private var password = ""
    
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
            
            Button("로그인") {
                if !email.isEmpty && !password.isEmpty {
                    isLoggedIn = true
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
