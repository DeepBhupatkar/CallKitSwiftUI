//
//  NotificationManager.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 05/08/24.
//

import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var shouldNavigate: Bool = false
    
    private init() {}
    
    func handleNotification(notification: UNNotification) {
        
        // Update the state to navigate to a new screen
        DispatchQueue.main.async {
            self.shouldNavigate = true
        }
    }
}

extension Notification.Name {
    static let callingStarted = Notification.Name("callingStarted")
    static let callAnswered = Notification.Name("callAnswered")
    static let meetingIdStored = Notification.Name("meetingIdStored")

}
