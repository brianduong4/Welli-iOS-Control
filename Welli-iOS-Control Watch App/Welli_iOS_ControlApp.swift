//
//  Welli_iOS_ControlApp.swift
//  Welli-iOS-Control Watch App
//
//  Created by Brian Duong on 4/13/23.
//

import SwiftUI

@main
struct Welli_iOS_Control_Watch_AppApp: App {
    @StateObject var environmentObject = WriteViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(environmentObject)
        }
    }
}
