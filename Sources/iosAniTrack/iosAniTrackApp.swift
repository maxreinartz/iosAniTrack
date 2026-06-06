import SwiftUI

@main
struct iosAniTrackApp: App {
    @AppStorage("loggedIn") var loggedIn: Bool = false
    @AppStorage("accessToken") private var accessToken: String = ""

    var body: some Scene {
        WindowGroup {
            if(loggedIn) {
                ContentView()
            } else {
                LoginView()
                    .onOpenURL { url in
                        if url.absoluteString.starts(with: "anitrack://") {
                            if let token = url.absoluteString.components(separatedBy: "access_token=").last {
                                loggedIn = true
                                accessToken = token
                            }
                        }
                    }
            }
        }
    }
}
