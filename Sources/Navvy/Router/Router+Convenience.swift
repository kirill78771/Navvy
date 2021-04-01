import SwiftUI

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
    
    public func dismiss(
        _ screenType: ScreenType,
        completion: (() -> Void)? = nil
    ) {
        self.perform(
            navigation: .dismiss,
            with: screenType,
            completion: completion
        )
    }
    
    public func dismiss(
        _ screenTypes: [ScreenType],
        completion: (() -> Void)? = nil
    ) {
        for (index, screenType) in screenTypes.enumerated() {
            dismiss(screenType) {
                if index == screenTypes.count - 1 {
                    completion?()
                }
            }
        }
    }
}
