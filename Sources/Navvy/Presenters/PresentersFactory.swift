import Foundation

public protocol PresentersFactoryProtocol: AnyObject {
    func makePresenters() -> [Presenter]
}

public final class PresentersFactory: PresentersFactoryProtocol {
    private let customPresenters: [Presenter.Type]
    public init(customPresenters: [Presenter.Type] = []) {
        self.customPresenters = customPresenters
    }
    public func makePresenters() -> [Presenter] {
        var presenters = [
            SheetPresenter(),
            NavigationLinkPresenter(),
        ] + customPresenters.map { $0.init() }
        if #available(iOS 14.0, *) {
            presenters.append(FullScreenCoverPresenter())
        }
        return presenters
    }
}
