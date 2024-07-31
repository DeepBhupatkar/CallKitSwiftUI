//
//  InitiateCall.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 31/07/24.
//

import Foundation
class InitiateCall: ObservableObject {
    @Published var otherUserID: String = ""
    private var userData = UserData() // Or use dependency injection to provide UserData
    

    
    func initiateCall() {
        userData.initiateCall(otherUserID: otherUserID)
    }
}
