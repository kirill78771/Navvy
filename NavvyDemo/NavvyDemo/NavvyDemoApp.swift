//
//  NavvyDemoApp.swift
//  NavvyDemo
//
//  Created by Kirill Tukaev on 10.10.2021.
//

import SwiftUI

@main
struct NavvyDemoApp: App {
    var body: some Scene {
        WindowGroup {
            router.setRootView(.root)
        }
    }
}
