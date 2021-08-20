import SwiftUI
import Combine

extension Router {

    public func presentSheet(
        _ screenType: ScreenType,
        completion: (() -> Void)? = nil
    ) {
        self.perform(
            navigation: .presentation(SheetPresenter.presentationType),
            with: screenType,
            completion: completion
        )
    }

    @available(iOS 14, *)
    public func presentOverFullScreen(
        _ screenType: ScreenType,
        completion: (() -> Void)? = nil
    ) {
        self.perform(
            navigation: .presentation(FullScreenCoverPresenter.presentationType),
            with: screenType,
            completion: completion
        )
    }

    public func navigationLink(
        _ screenType: ScreenType,
        completion: (() -> Void)? = nil
    ) {
        self.perform(
            navigation: .presentation(NavigationLinkPresenter.presentationType),
            with: screenType,
            completion: completion
        )
    }
}
