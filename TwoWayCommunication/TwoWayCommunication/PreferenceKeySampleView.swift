import SwiftUI

struct PreferenceKeySampleView: View {
    let threshold = 95
    let max = 100
    @State var color: Color = .red

    var body: some View {
        List(0...100, id: \.self) { _ in
            PreferenceChildView(threshold: self.threshold, max: self.max)
        }
        .onPreferenceChange(MyPreferenceKey.self) { value in
            self.color = value ? .red : .black
            print(value)
        }
        .foregroundColor(color)
        .navigationBarTitle("Preference Key")
    }
}

struct PreferenceChildView: View {
    let threshold: Int
    let max: Int
    @State var number: Int = 0

    var body: some View {
        HStack {
            Spacer()
            Text("\(number)")
        }
        .onAppear {
            self.number = Int.random(in: 0...self.max)
        }
        .onDisappear {
            self.number = 0
        }
        .background(greaterThanThreshold ? Color.green : Color.white)
        .preference(key: MyPreferenceKey.self, value: greaterThanThreshold)
    }

    var greaterThanThreshold: Bool {
        return number > threshold
    }
}

struct MyPreferenceKey: PreferenceKey {
    typealias Value = Bool
    static var defaultValue: Value = false
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue() || value
    }
}
