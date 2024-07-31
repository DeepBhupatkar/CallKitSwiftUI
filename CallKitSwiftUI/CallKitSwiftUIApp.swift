//
//  CallKitSwiftUIApp.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

//import SwiftUI
//import Firebase
//
//@main
//struct CallKitSwiftUIApp: App {
//    init() {
//        FirebaseApp.configure()
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

import SwiftUI

import FirebaseCore

@main
struct CallKitSwiftUIApp: App {
    // Link AppDelegate to the SwiftUI lifecycle
    @StateObject private var userData = UserData()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    init() {
//          FirebaseApp.configure()
//      }
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .onAppear {
//                                    // Trigger initiateCall based on some condition or event
//                                    userData.initiateCall(otherUserID: "21203")
//                                }
        }
    }
}

