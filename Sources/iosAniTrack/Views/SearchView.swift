import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Search View")
                        .font(.title)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
