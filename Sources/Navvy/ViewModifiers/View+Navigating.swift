import SwiftUI

struct NavigatableScreenModifier: ViewModifier {
    @ObservedObject private(set) var model: NavigatableScreenViewModel

    func body(content: Content) -> some View {
        ZStack {
            content
            ForEach(model.presenters) {
                $0.viewAppendix(destinationViewProvider: { [unowned model] in
                    model.destinationView
                })
            }
        }
    }
}

extension View {
    func navigating(with model: NavigatableScreenViewModel) -> some View {
        self.modifier(NavigatableScreenModifier(model: model))
    }
}
