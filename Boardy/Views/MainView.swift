import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text("Main")
                .font(.title)
                .padding()
            Text("메인 화면입니다.")
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
