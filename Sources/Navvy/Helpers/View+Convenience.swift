import SwiftUI

extension View {
    
    func toAnyView() -> AnyView {
        AnyView(self)
    }
    
    func embedInNavigationView() -> some View {
        NavigationView { self }
            // This is a fix for the autolayout warning in the console.
            // More information can be found here:
            // https://stackoverflow.com/questions/65316497/swiftui-navigationview-navigationbartitle-layoutconstraints-issue/65318356
            .navigationViewStyle(StackNavigationViewStyle())
    }
}
