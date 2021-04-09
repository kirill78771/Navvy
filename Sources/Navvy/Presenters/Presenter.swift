import SwiftUI
import Combine

// TODO:
// 1. Safe & typed presentation type
// 2. Type erasure for protocol instead of abstract class

public protocol PresenterProtocol: ObservableObject, Identifiable {
    static var presentationType: String { get }
    var isPresenting: Bool { get set }
    func viewAppendix(destinationViewProvider: @escaping () -> AnyView) -> AnyView
}

open class Presenter: PresenterProtocol {
    @Published public var isPresenting = false
    public var isPresentingBinding: Binding<Bool> {
        Binding(
            get: { self.isPresenting },
            set: { self.isPresenting = $0 }
        )
    }
    open class var presentationType: String {
        fatalError("Override in subclass")
    }
    open func viewAppendix(destinationViewProvider: @escaping () -> AnyView) -> AnyView {
        fatalError("Override in subclass")
    }

    public required init() { }
}

// MARK: - Default presenters

public final class SheetPresenter: Presenter {

    public override class var presentationType: String {
        "sheet"
    }
    
    public override func viewAppendix(destinationViewProvider: @escaping () -> AnyView) -> AnyView {
        EmptyView().sheet(
            isPresented: isPresentingBinding,
            content: { destinationViewProvider() }
        ).toAnyView()
    }
}

public final class NavigationLinkPresenter: Presenter {

    public override class var presentationType: String {
        "navigationLink"
    }

    public override func viewAppendix(destinationViewProvider: @escaping () -> AnyView) -> AnyView {
        NavigationLink(
            destination: destinationViewProvider(),
            isActive: isPresentingBinding,
            label: { EmptyView() }
        ).toAnyView()
    }
}

@available(iOS 14, *)
public final class FullScreenCoverPresenter: Presenter {

    public override class var presentationType: String {
        "fullScreenCover"
    }

    public override func viewAppendix(destinationViewProvider: @escaping () -> AnyView) -> AnyView {
        EmptyView().compatibleFullScreen(
            isPresented: isPresentingBinding,
            content: { destinationViewProvider() }
        ).toAnyView()
    }
}
