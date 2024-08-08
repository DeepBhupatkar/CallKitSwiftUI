//
//  TokenManager.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 07/08/24.
//

import Foundation


/// MARK: Singleton Class For Device,FMC Token Store and For OtherUserID

//MARK: DeviceTokenManager

class DeviceTokenManager {
    static let shared = DeviceTokenManager()
    private init() {}

    var deviceToken: String?
}
//MARK: FCMTokenManager

class FCMTokenManager{
    
    static let sharedFCM = FCMTokenManager()
    private init() {}
    
    var FCMTokenOfDevice: String?
}

//MARK: OtherUserManager

class OtherUserIDManager{
    
    static let SharedOtherUID = OtherUserIDManager()
    private init() {}
    
    var OtherUIDOf: String?
}

//

class MeetingManager {
    static let shared = MeetingManager()
    private init() {}
    
    var currentMeetingID: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentMeetingID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentMeetingID")
        }
    }
}
