import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image(systemName: "person.circle")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Profile View")
                        .font(.title)
                        .padding()
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}
