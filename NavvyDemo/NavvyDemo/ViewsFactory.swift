//
//  ViewsFactory.swift
//  NavvyDemo
//
//  Created by Kirill Tukaev on 10.10.2021.
//

import SwiftUI

final class ViewsFactory: ViewsFactoryProtocol {
    typealias ScreenType = NavvyDemo.ScreenType

    func makeView(for screenType: ScreenType) -> AnyView {
        switch screenType {
        case .root: return ContentView().toAnyView()
        case .fullScreen: return FullScreenView().toAnyView()
        case .push: return PushView().toAnyView()
        case .sheet: return SheetView().toAnyView()
        }
    }
}
