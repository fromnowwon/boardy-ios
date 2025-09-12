import SwiftUI

@main
struct BoardyApp: App {
    @State private var showSplash = true
    
    var body: some Scene {
            WindowGroup {
                NavigationStack {
                    RootView()
                }
            }
        }
}



