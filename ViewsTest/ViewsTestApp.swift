//
//  ViewsTestApp.swift
//  ViewsTest
//
//  Created by Tadashi Ogino on 2021/08/19.
//

import SwiftUI

@main
struct ViewsTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppData())
                .environmentObject(AppAxes())
                .environmentObject(CalcParams())
        }
    }
}
