import SwiftUI

public protocol ViewsFactoryProtocol {
    associatedtype ScreenType
    func makeView(for screenType: ScreenType) -> AnyView
}
