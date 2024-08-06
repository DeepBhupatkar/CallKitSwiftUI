//
//  CallKitSwiftUIApp.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

import SwiftUI

import FirebaseCore

@main
struct CallKitSwiftUIApp: App {
    // Link AppDelegate to the SwiftUI lifecycle
    @StateObject private var userData = UserData()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            JoinView()

        }
    }
}

