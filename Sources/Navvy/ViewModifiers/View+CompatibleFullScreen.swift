import SwiftUI

extension View {
    func compatibleFullScreen<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(FullScreenModifier(isPresented: isPresented, content: content))
    }
}

struct FullScreenModifier<V: View>: ViewModifier {
    let isPresented: Binding<Bool>
    let content: () -> V

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content.fullScreenCover(isPresented: isPresented, content: self.content)
        } else {
            content
        }
    }
}
