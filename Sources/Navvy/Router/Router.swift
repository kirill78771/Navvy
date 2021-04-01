import SwiftUI
import Combine

public protocol ScreenTypeProtocol: Equatable {
    var embedInNavigation: Bool { get }
}

public final class Router<ScreenType: ScreenTypeProtocol>: ObservableObject {

    private let queue = NavigationQueue()
    private let viewsFactory: (ScreenType) -> AnyView
    private let presentersFactory: PresentersFactoryProtocol
    private var stack = [PresentationContext]()

    // MARK: - Init
    
    public init<T: ViewsFactoryProtocol>(
        viewsFactory: T,
        presentersFactory: PresentersFactoryProtocol
    ) where T.ScreenType == ScreenType {
        self.viewsFactory = viewsFactory.makeView
        self.presentersFactory = presentersFactory
    }
    
    // MARK: -
    
    public func setRootView(
        _ screenType: ScreenType
    ) -> AnyView {
        let context = self.makePresentationContext(for: screenType)
        self.stack = [context]
        return self.view(for: context)
    }

    public func perform(
        navigation: NavigationType,
        with screenType: ScreenType,
        completion: (() -> Void)? = nil
    ) {
        switch navigation {
        case .presentation(let type):
            self.performPresentOperation(
                screenType: screenType,
                presentationType: type,
                completion: completion
            )
        case .dismiss:
            self.performDismissOperation(
                screenType,
                completion: completion
            )
        }
    }

    public func performPresentOperation(
        screenType: ScreenType,
        presentationType: String,
        completion: (() -> Void)?
    ) {
        self.queue.perform { [weak self] queueCompletion in
            guard let self = self else { return }
            let completion: () -> Void = {
                completion?()
                queueCompletion()
            }
            let context = self.makePresentationContext(for: screenType)
            let view = self.view(
                for: context
            )
            let presentingModel = self.stack.last?.screenViewModel
            presentingModel?.show(view, presentationType: presentationType, completion: completion)
            self.stack.append(context)
        }
    }

    private func performDismissOperation(
        _ screenType: ScreenType,
        completion: (() -> Void)? = nil
    ) {
        self.queue.perform { [weak self] queueCompletion in
            guard let self = self else { return }
            let completion: () -> Void = {
                completion?()
                queueCompletion()
            }
            guard let index = self.stack.firstIndex(where: { $0.screenType == screenType }) else {
                assertionFailure("Attempt to dismiss non-existing screen")
                completion()
                return
            }
            let dismissingIndex = index - 1
            guard self.stack.indices.contains(dismissingIndex) else {
                assertionFailure("Attempt to dismiss root screen")
                completion()
                return
            }
            self.stack[dismissingIndex].screenViewModel.dismiss(completion: completion)
        }
    }

    private func makePresentationContext(for screenType: ScreenType) -> PresentationContext {
        let viewModel = NavigatableScreenViewModel(
            presenters: presentersFactory.makePresenters()
        )
        let subscriptions: [Cancellable] = viewModel.showsViewPublishers.map {
            $0.sink { [weak self] isVisible in
                guard !isVisible else { return }
                self?.cleanUpStack()
            }
        }
        return PresentationContext(
            screenType: screenType,
            screenViewModel: viewModel,
            subscriptions: subscriptions
        )
    }

    private func cleanUpStack() {
        guard let lastVisibleScreenIndex = stack.firstIndex(
            where: { !$0.screenViewModel.showsView }
        ) else {
            return
        }
        self.stack = Array(self.stack[0...lastVisibleScreenIndex])
    }

    private func view(
        for context: PresentationContext
    ) -> AnyView {
        let view = viewsFactory(context.screenType)
            .navigating(with: context.screenViewModel)
        return context.screenType.embedInNavigation
            ? view.embedInNavigationView().toAnyView()
            : view.toAnyView()
    }
}
