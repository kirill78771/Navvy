import Foundation

public protocol PresentersFactoryProtocol: AnyObject {
    func makePresenters() -> [Presenter]
}

public final class PresentersFactory: PresentersFactoryProtocol {
    private let customPresenters: [Presenter]
    public init(customPresenters: [Presenter] = []) {
        self.customPresenters = customPresenters
    }
    public func makePresenters() -> [Presenter] {
        var presenters = [
            SheetPresenter(),
            NavigationLinkPresenter(),
        ] + customPresenters
        if #available(iOS 14.0, *) {
            presenters.append(FullScreenCoverPresenter())
        }
        return presenters
    }
}
