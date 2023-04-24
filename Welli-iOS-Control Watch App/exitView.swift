//
//  exitView.swift
//  Welli-iOS-Control Watch App
//
//  Created by Brian Duong on 4/13/23.
//

import SwiftUI
import WatchKit
struct exitView: View {
    
    var body: some View {
        VStack {
            Text("Thank you for sharing your feelings with us").bold()
            Button(action: {
                WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: Date(), userInfo: nil) { _ in
                                exit(0)
                            }
                    }) {
                        Text("Exit")
                    }.foregroundColor(.red)
        }
    }
}


struct exitView_Previews: PreviewProvider {
    static var previews: some View {
        exitView()
    }
}
