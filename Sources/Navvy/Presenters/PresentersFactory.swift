import Foundation

public protocol PresentersFactoryProtocol: AnyObject {
    func makePresenters() -> [Presenter]
}

public final class PresentersFactory: PresentersFactoryProtocol {
    private let customPresenterFactories: [() -> Presenter]
    public init(customPresenterFactories: [() -> Presenter] = []) {
        self.customPresenterFactories = customPresenterFactories
    }
    public func makePresenters() -> [Presenter] {
        var presenters = [
            SheetPresenter(),
            NavigationLinkPresenter(),
        ] + customPresenterFactories.map { $0() }
        if #available(iOS 14.0, *) {
            presenters.append(FullScreenCoverPresenter())
        }
        return presenters
    }
}
