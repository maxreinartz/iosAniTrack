import SwiftUI

struct ListView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image(systemName: "list.bullet")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("List View")
                        .font(.title)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
