import SwiftUI
import Combine

final class NavigatableScreenViewModel: ObservableObject {
    let presenters: [Presenter]
    @Published var destinationView: AnyView = EmptyView().toAnyView()

    private var dismissCompletion: (() -> Void)?

    init(presenters: [Presenter]) {
        self.presenters = presenters
    }

    // MARK: - Actions

    func show(
        _ view: AnyView,
        presentationType: String,
        completion: (() -> Void)?
    ) {
        setDestinationView(view, completion: completion)
        guard let presenter = presenters.first(
                where: { type(of: $0).presentationType == presentationType }
        ) else {
            assertionFailure("No presenters registered for presentation type \(presentationType)")
            return
        }
        presenter.isPresenting = true
    }

    func dismiss(
        completion: (() -> Void)?
    ) {
        dismissFlag()
        dismissCompletion = completion
        destinationView = EmptyView().toAnyView()
    }

    // MARK: - Helpers

    var showsView: Bool {
        let flags = presenters
            .map { $0.isPresenting ? 1 : 0 }
            .reduce(0, +)
        assert(flags == 0 || flags == 1)
        return flags > 0
    }

    var showsViewPublishers: [Published<Bool>.Publisher] {
        return presenters.map { $0.$isPresenting }
    }

    // MARK: - Private

    private func setDestinationView(
        _ view: AnyView,
        completion: (() -> Void)?
    ) {
        var didAppear = false
        destinationView = view
            .onAppear {
                guard !didAppear else { return }
                didAppear = true
                completion?()
            }
            .onDisappear {
                self.dismissCompletion?()
                self.dismissCompletion = nil
            }
            .toAnyView()
    }

    private func dismissFlag() {
        presenters.forEach {
            guard $0.isPresenting else { return }
            $0.isPresenting = false
        }
    }
}
