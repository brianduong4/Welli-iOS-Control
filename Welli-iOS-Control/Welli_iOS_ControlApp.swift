//
//  Welli_iOS_ControlApp.swift
//  Welli-iOS-Control
//
//  Created by Brian Duong on 4/13/23.
//

import SwiftUI
import Firebase

@main
struct Welli_iOS_ControlApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
