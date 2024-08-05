//
//  User.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

import Foundation

struct User: Identifiable {
    let id: String
    let name: String
    let callerID: String
    let deviceToken : String
    let fcmToken : String
}
