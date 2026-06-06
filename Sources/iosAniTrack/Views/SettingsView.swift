import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Settings View")
                        .font(.title)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
