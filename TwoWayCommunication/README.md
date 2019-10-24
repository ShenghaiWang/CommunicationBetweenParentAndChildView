# Two-way communication between parent and child views
## From Parent to Child

### Environment

#### A linked View property that reads a value from the view's environment. 
#### Sample:

        public var sizeCategory: ContentSizeCategory
        public var managedObjectContext: NSManagedObjectContext
        public var layoutDirection: LayoutDirection
        public var presentationMode: Binding<PresentationMode>

#### Usage:

        @Environment(\.presentationMode) var presentationMode

### EnvironmentObject

A linked View property that reads a `ObservableObject` supplied by an
ancestor view that will automatically invalidate its view when the object
changes.
- Precondition: A model must be provided on an ancestor view by calling
    `environmentObject(_:)`.
    
`Only visible to the current view and its child views (Not including the sheet, 
alert, action sheet etc. that popped up from it and its children)`

### Define your own Environment Values
#### Works in the same way as Environment

        public protocol EnvironmentKey {
            associatedtype Value
            static var defaultValue: Self.Value { get }
        }
    
        extension EnvironmentValues {
            var myKey: Bool {
            get { self[MyEnvironmentKey.self] }
            set { self[MyEnvironmentKey.self] = newValue}
            }
        }
    
#### Usage:
        same as environment values definied in SwiftUI

#### Why?
**Visible to all views without injecting it like `EnvironmentObject`**

## From Child to Parent

### Preference
#### what is it?
A named value produced by a view. Views with multiple children
automatically combine all child values into a single value visible
to their ancestors.

    public protocol PreferenceKey {
        associatedtype Value
        static var defaultValue: Self.Value { get }
        static func reduce(value: inout Self.Value, nextValue: () -> Self.Value)
    }
#### Why?
To collect values of child views that parent view needs. Possibly child view frame? status?

#### SwiftUI defined preference Example: 
    `navigationBarTitle`

#### Customised preference Key
##### Define key
    struct MyPreferenceKey: PreferenceKey {
        typealias Value = Bool
        static var defaultValue: Value = false
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = nextValue() || value
        }
    }
##### Set value in child view
    .preference(key: MyPreferenceKey.self, value: true)

Or:

    .anchorPreference(key: <#T##PreferenceKey.Protocol#>, 
                      value: <#T##Anchor<A>.Source#>, 
                      transform: <#T##(Anchor<A>) -> PreferenceKey.Value#>)
    .transformAnchorPreference(key: <#T##PreferenceKey.Protocol#>, 
                               value: <#T##Anchor<A>.Source#>, 
                               transform: <#T##(inout PreferenceKey.Value, Anchor<A>) -> Void#>)
##### Access values in parent view
    .onPreferenceChange(MyPreferenceKey.self) { value in }

Or:


    .backgroundPreferenceValue(<#T##key: PreferenceKey.Protocol##PreferenceKey.Protocol#>, 
                               <#T##transform: (PreferenceKey.Value) -> View##(PreferenceKey.Value) -> View#>)
    .overlayPreferenceValue(<#T##key: PreferenceKey.Protocol##PreferenceKey.Protocol#>, 
                            <#T##transform: (PreferenceKey.Value) -> View##(PreferenceKey.Value) -> View#>)
    

##### Make it look like the swiftUI native
View modifiers or View extension to help
**View extension**

        extension View {
            func myPreference(_ value: Bool) -> some View {
                preference(key: MyPreferenceKey.self, value: value)
            }
        }

**View modifiers**
1. define it

        struct MyPreferenceViewModifier: ViewModifier {
            let value: Bool
            func body(content: Content) -> some View {
                content
                    .preference(key: MyPreferenceKey.self, value: value)
            }
        }
        
2. Use it directly
 
        .modifier(MyPreferenceViewModifier(value: true))

3. Wrap it in view extension

        extension View {
            func myPreference(_ value: Bool) -> some View {
                modifier(MyPreferenceViewModifier(value: value))
            }
        }
