//
//  SetApp.swift
//  Set
//
//  Created by Dana Zou on 13/11/2022.
//

import SwiftUI

@main
struct SetApp: App {
    let game = ClassicalSetGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
