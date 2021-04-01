import Combine
import SwiftUI

extension Router {
    
    final class PresentationContext {
        
        let screenType: ScreenType
        let screenViewModel: NavigatableScreenViewModel
        let subscriptions: [Cancellable]
        
        init(
            screenType: ScreenType,
            screenViewModel: NavigatableScreenViewModel,
            subscriptions: [Cancellable]
        ) {
            self.screenType = screenType
            self.screenViewModel = screenViewModel
            self.subscriptions = subscriptions
        }
    }

    public enum NavigationType {
        case presentation(String)
        case dismiss
    }
}
