//
//  ContentView.swift
//  NavvyDemo
//
//  Created by Kirill Tukaev on 10.10.2021.
//

import SwiftUI

enum ScreenType: ScreenTypeProtocol {
    case root
    case sheet
    case fullScreen
    case push

    var embedInNavigation: Bool {
        switch self {
        case .fullScreen, .sheet, .root:
            return true
        case .push:
            return false
        }
    }
}

let router = Router(
    viewsFactory: ViewsFactory(),
    presentersFactory: PresentersFactory(
        customPresenterFactories: []
    )
)

struct ContentView: View {

    var body: some View {
        VStack(spacing: 32.0) {
            Button("FullScreen") {
                router.presentOverFullScreen(.fullScreen, completion: nil)
            }
            Button("Sheet") {
                router.presentSheet(.sheet, completion: nil)
            }
            Button("Push") {
                router.navigationLink(.push, completion: nil)
            }
        }
    }
}

struct FullScreenView: View {
    var body: some View {
        Text("FullScreen")
            .navigationBarItems(leading:
                Button("Back", action: {
                    router.dismissLast(completion: nil)
                })
            )
    }
}

struct SheetView: View {
    var body: some View {
        Text("Sheet")
            .navigationBarItems(leading:
                Button("Back", action: {
                    router.dismissLast(completion: nil)
                })
            )
    }
}

struct PushView: View {
    var body: some View {
        Text("Push")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button("Back", action: {
                    router.dismissLast(completion: nil)
                })
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
