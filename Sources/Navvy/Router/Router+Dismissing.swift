import SwiftUI
import Combine

extension Router {

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

    public func dismissLast(completion: (() -> Void)? = nil) {
        guard let screenType = stack.last?.screenType else {
            assertionFailure("Stack shouldn't be empty")
            return
        }
        self.perform(
            navigation: .dismiss,
            with: screenType,
            completion: completion
        )
    }
}
