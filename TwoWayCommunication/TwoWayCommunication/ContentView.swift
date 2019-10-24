import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Divider()
                    NavigationLink(destination: EnviromentValueSampleView()) {
                        Text("Enviroment Value Sample")
                    }
                    Divider()
                    NavigationLink(destination: PreferenceKeySampleView()) {
                        Text("View Preference Sample")
                    }
                    Divider()
                }
            }
            .navigationBarTitle("iOS chapter")
        }
    }
}
