import SwiftUI

struct LoginView: View {
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("AniTrack")
                .font(.largeTitle)
                .padding()
            
            Button("Login with AniList") {
                if let url = URL(string: "https://anilist.co/api/v2/oauth/authorize?client_id=28046&response_type=token") {
                    UIApplication.shared.open(url)
                }
            }.buttonStyle(.borderedProminent)
            .controlSize(.large)
            .buttonBorderShape(.automatic)
        }
        .padding()
    }
}
