import SwiftUI

struct NotificationsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image(systemName: "bell")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Notifications View")
                        .font(.title)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("Notifications")
        }
    }
}
