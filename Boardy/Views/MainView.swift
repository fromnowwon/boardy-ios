import SwiftUI

struct MainView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some View {
        VStack {
            Text("Main")
                .font(.title)
                .padding()
            Text("메인 화면입니다.")
                .padding()
            Button(action: {
                // 로그아웃 처리
                isLoggedIn = false
                print("로그아웃 완료. 로그인 화면으로 돌아갑니다.")
            }) {
                Text("로그아웃")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
