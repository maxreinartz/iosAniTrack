import SwiftUI

private func normalizeAccessToken(_ rawToken: String) -> String {
    var token = rawToken.trimmingCharacters(in: .whitespacesAndNewlines)

    if let hashIndex = token.firstIndex(of: "#") {
        token = String(token[token.index(after: hashIndex)...])
    }

    if token.contains("access_token=") {
        token = token.components(separatedBy: "access_token=").last ?? token
    }

    if let ampIndex = token.firstIndex(of: "&") {
        token = String(token[..<ampIndex])
    }

    if let questionIndex = token.firstIndex(of: "?") {
        token = String(token[..<questionIndex])
    }

    return token.removingPercentEncoding ?? token
}

private func extractAccessToken(from url: URL) -> String? {
    guard let fragment = url.fragment else {
        return nil
    }

    let items = fragment.split(separator: "&")
    for item in items {
        let pair = item.split(separator: "=", maxSplits: 1)
        if pair.count == 2, pair[0] == "access_token" {
            return normalizeAccessToken(String(pair[1]))
        }
    }

    return nil
}

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
                            if let token = extractAccessToken(from: url), !token.isEmpty {
                                loggedIn = true
                                accessToken = token
                            }
                        }
                    }
            }
        }
    }
}
