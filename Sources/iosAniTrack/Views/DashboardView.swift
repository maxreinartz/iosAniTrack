import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image(systemName: "house")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Dashboard View")
                        .font(.title)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
