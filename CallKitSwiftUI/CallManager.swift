//
//  CallManager.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 01/08/24.
//

import CallKit

class CallManager {
    static let shared = CallManager()
    private let callController = CXCallController()
    
    private init() {}
    
    func endCall(callUUID: UUID) {
        let endCallAction = CXEndCallAction(call: callUUID)
        let transaction = CXTransaction(action: endCallAction)
        
        callController.request(transaction) { error in
            if let error = error {
                print("Error ending call: \(error)")
            } else {
                print("Call ended successfully")
            }
        }
    }
}
