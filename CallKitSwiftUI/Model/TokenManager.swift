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

//MARK: MeetingManager For keeping Track of meetingID

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

//MARK: CallManager

class CallManager {
    static let shared = CallManager()
    
    private init() {}
    
    var activeCallUUID: UUID?
    var callerIDs: [UUID: String] = [:]
    
    func clearActiveCall() {
        activeCallUUID = nil
    }
    
    func addCallerID(uuid: UUID, callerID: String) {
        callerIDs[uuid] = callerID
    }
    
    func removeCallerID(uuid: UUID) {
        callerIDs.removeValue(forKey: uuid)
    }
    
    func getCallerID(uuid: UUID) -> String? {
        return callerIDs[uuid]
    }
    func clearAllCallerIDs() {
          callerIDs.removeAll()
      }
}
