import SwiftUI
import Combine

public protocol ScreenTypeProtocol: Equatable {
    var embedInNavigation: Bool { get }
}

public final class Router<ScreenType: ScreenTypeProtocol>: ObservableObject {

    internal let queue = NavigationQueue()
    internal let viewsFactory: (ScreenType) -> AnyView
    internal let presentersFactory: PresentersFactoryProtocol
    internal var stack = [PresentationContext]()

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

    internal func performDismissOperation(
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

    internal func makePresentationContext(for screenType: ScreenType) -> PresentationContext {
        let viewModel = NavigatableScreenViewModel(
            presenters: presentersFactory.makePresenters()
        )
        let subscriptions: [Cancellable] = viewModel.showsViewPublishers.map { [weak viewModel] in
            $0.sink { [weak self] isPresenting in
                guard !isPresenting, let viewModel = viewModel else { return }
                self?.cleanStack(after: viewModel)
            }
        }
        return PresentationContext(
            screenType: screenType,
            screenViewModel: viewModel,
            subscriptions: subscriptions
        )
    }

    internal func cleanStack(after viewModel: NavigatableScreenViewModel) {
        guard let lastVisibleScreenIndex = stack.firstIndex(
            where: { $0.screenViewModel === viewModel }
        ) else {
            return
        }
        self.stack = Array(self.stack[0...lastVisibleScreenIndex])
    }

    internal func view(
        for context: PresentationContext
    ) -> AnyView {
        let view = viewsFactory(context.screenType)
            .navigating(with: context.screenViewModel)
        return context.screenType.embedInNavigation
            ? view.embedInNavigationView().toAnyView()
            : view.toAnyView()
    }
}
