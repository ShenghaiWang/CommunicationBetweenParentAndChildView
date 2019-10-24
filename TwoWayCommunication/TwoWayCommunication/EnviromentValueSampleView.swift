import SwiftUI

struct EnviromentValueSampleView: View {
    @Environment(\.myEnvironmentValue) var myEnvironmentValue
    @State var myValue = false
    var body: some View {
        VStack {
            Divider()
            Text("In Parent View: \(String(describing: myEnvironmentValue))")
            Divider()
            ChildView().environment(\.myEnvironmentValue, myValue)
            Button(action: {
                self.myValue.toggle()
            }, label: {
                Text("Update me")
            })
        }
        .navigationBarTitle("Enviroment Value")
    }
}

struct ChildView: View {
    @Environment(\.myEnvironmentValue) var myEnvironmentValue

    var body: some View {
        VStack {
            Text("In Child View: \(String(describing: myEnvironmentValue))")
            Divider()
            GrandChildView()
            Divider()
        }
    }
}

struct GrandChildView: View {
    @Environment(\.myEnvironmentValue) var myEnvironmentValue

    var body: some View {
        Text("In Grand Child View: \(String(describing: myEnvironmentValue))")
    }
}

struct MyEnvironmentKey: EnvironmentKey {
    static var defaultValue = true
}

extension EnvironmentValues {
    var myEnvironmentValue: Bool {
        get { self[MyEnvironmentKey.self] }
        set { self[MyEnvironmentKey.self] = newValue}
    }
}

