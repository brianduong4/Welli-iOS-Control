//
//  WriteViewModel.swift
//  welli Watch App
//
//  Created by Brian Duong on 3/8/23.
//

import Foundation
import UIKit
import SwiftUI
import WatchConnectivity
import WatchKit


class WriteViewModel: NSObject, WCSessionDelegate, ObservableObject{
    @Published var data: [String: String] = [:]
    
    var session: WCSession
    @Published var messageText = ""
    
    init(session: WCSession = .default){
        self.session = session
        super.init()
        self.session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    //MARK: RECIEVE REWARD
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.messageText = message["message"] as? String ?? "Unknown"
            
            print(self.messageText)
        }
    }
        
    
    
    //MARK: SEND DATA
    func sendDictionaryToiOSApp(_ dictionary: [String: Any]) {
        let session = WCSession.default
        if session.isReachable {
            print("ios connection reachable")
            print("Sending dictionary: \(dictionary)")
            session.sendMessage(dictionary, replyHandler: nil, errorHandler: nil)
        }
    }
}

class InterfaceController: WKInterfaceController {
    
    var sessionDelegate = WriteViewModel()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Set the delegate for the WCSession instance
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = sessionDelegate
            session.activate()
        }
    }
    
    // Other methods of the InterfaceController class go here
    
}

//MARK: current date & time
class MyStruct: ObservableObject{
    @Published var currentDate: String
    @Published var currentMilitary: String
    
    init() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm:ss"
        currentMilitary = formatter.string(from: now)
        formatter.dateStyle = .short
        //formatter.timeStyle = .short
        
        currentDate = formatter.string(from: now)
    }
}

var myInstance = MyStruct()
//MARK: END of date & time



