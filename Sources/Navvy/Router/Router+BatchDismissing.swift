import SwiftUI
import Combine

extension Router {

    internal func dismissAsFuture(_ screenType: ScreenType) -> Deferred<Future<Void, Never>> {
        Deferred {
            Future { promise in
                self.dismiss(screenType) {
                    promise(Result.success(()))
                }
            }
        }
    }

    public func dismiss(
        _ screenTypes: [ScreenType],
        completion: (() -> Void)? = nil
    ) {
        batchDismissingSubscription = screenTypes
            .map { dismissAsFuture($0) }
            .serialize()?
            .sink(
                receiveCompletion: { _ in
                    completion?()
                }, receiveValue: { }
            )
    }
}
