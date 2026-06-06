import SwiftUI

struct LoginView: View {
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 40)

                Text("Welcome to AniTrack! Please log in to get started.")
                    .font(.body)
                    .padding()
                
                Button("Login with AniList") {
                    if let url = URL(string: "https://anilist.co/api/v2/oauth/authorize?client_id=28046&response_type=token") {
                        UIApplication.shared.open(url)
                    }
                }.buttonStyle(.borderedProminent)
                .controlSize(.large)
                .buttonBorderShape(.automatic)
                .tint(.primary)
                .foregroundStyle(.background)

                Text("Don't have an account? Sign up on AniList.")
                    .font(.footnote)
                    .padding(.top, 20)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
