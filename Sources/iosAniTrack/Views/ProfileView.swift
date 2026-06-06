import SwiftUI
import Foundation

private func decodeNumericEntities(_ text: String) -> String {
    let pattern = "&#(x?[0-9A-Fa-f]+);?"
    guard let regex = try? NSRegularExpression(pattern: pattern) else {
        return text
    }

    let nsText = text as NSString
    let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsText.length)).reversed()
    var result = text

    for match in matches {
        guard match.numberOfRanges >= 2 else { continue }
        let entityRange = match.range(at: 0)
        let valueRange = match.range(at: 1)
        let rawValue = nsText.substring(with: valueRange)

        let scalarValue: UInt32?
        if rawValue.lowercased().hasPrefix("x") {
            scalarValue = UInt32(rawValue.dropFirst(), radix: 16)
        } else {
            scalarValue = UInt32(rawValue, radix: 10)
        }

        if let scalarValue, let unicodeScalar = UnicodeScalar(scalarValue) {
            let replacement = String(Character(unicodeScalar))
            if let swiftRange = Range(entityRange, in: result) {
                result.replaceSubrange(swiftRange, with: replacement)
            }
        }
    }

    return result
}

private func decodeAniListText(_ text: String) -> String {
    let normalized = text.replacingOccurrences(of: "&%", with: "&#")

    let namedEntityMap: [String: String] = [
        "&amp;": "&",
        "&lt;": "<",
        "&gt;": ">",
        "&quot;": "\"",
        "&#39;": "'",
        "&apos;": "'",
    ]

    let withNamedEntitiesDecoded = namedEntityMap.reduce(normalized) { partial, entry in
        partial.replacingOccurrences(of: entry.key, with: entry.value)
    }

    return decodeNumericEntities(withNamedEntitiesDecoded)
}

struct ProfileView: View {
    @State private var name: String? = nil
    @State private var about: String? = nil
    @State private var avatarURL: String? = nil
    @State private var bannerURL: String? = nil
    @State private var isLoading = false
    @State private var errorMessage: String? = nil

    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack (alignment: .top) {
                    VStack(spacing: 16) {
                        ZStack {
                            if let bannerURL, let url = URL(string: bannerURL) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(maxWidth: geometry.size.width)
                        .frame(height: 150)
                        .clipped()
                        .overlay(
                            Group {
                                if let avatarURL, let url = URL(string: avatarURL) {
                                    AsyncImage(url: url) { image in
                                        image                                        .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 15))
                                            .offset(y: 25)
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 100, height: 100)
                                            .offset(y: 25)
                                    }
                                } else {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 100, height: 100)
                                        .offset(y: 25)
                                }
                            }, alignment: .bottom
                        )
                        
                        if let name {
                            Text(name)
                                .font(.title)
                                .padding(.top, 30)
                        } else if isLoading {
                            ProgressView()
                        } else {
                            Text("Unknown")
                                .font(.title)
                                .foregroundStyle(.secondary)
                        }

                        if let about {
                            Text(about)
                                .font(.body)
                                .padding()
                        } else if isLoading {
                            ProgressView()
                        } else {
                            Text("Unknown")
                                .font(.title)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gear")
                                .imageScale(.large)
                                .foregroundStyle(.tint)
                        }
                    }
                }
                .task {
                    await loadViewer()
                }
            }
        }
    }

    private func loadViewer() async {
        isLoading = true
        errorMessage = nil
        do {
            let viewerData = try await fetchViewerData()
            if let name = viewerData["name"] as? String {
                self.name = name
            } else {
                self.name = "Unknown"
            }
            if let about = viewerData["about"] as? String {
                self.about = decodeAniListText(about)
            }
            if let avatar = viewerData["avatar"] as? [String: Any], let large = avatar["large"] as? String {
                self.avatarURL = large
            }
            if let bannerImage = viewerData["bannerImage"] as? String {
                self.bannerURL = bannerImage
            }

        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}