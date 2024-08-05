//
//  AppDelegate.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 31/07/24.
//

import UIKit
import PushKit
import CallKit
import UserNotifications
import AVFoundation
import FirebaseCore
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    var callObserver: CXCallObserver!
    var callController: CXCallController!
    var callProvider: CXProvider!
    
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    // Store caller IDs
      var callerIDs: [UUID: String] = [:]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        self.callObserver = CXCallObserver()
        self.callController = CXCallController()
        self.callProvider = CXProvider(configuration: CXProviderConfiguration(localizedName: "In VideoSDK Callkit Demo"))
        self.callProvider.setDelegate(self, queue: nil)
        
        self.registerForPushNotifications()
        self.voipRegistration()
    
        self.requestMicrophonePermission()
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        
        return true
    }
    
    // MARK: - Handle Incoming Calls with CallKit
    func reportIncomingCall(callerName: String) {
        let uuid = UUID()
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: callerName)
        update.localizedCallerName = callerName
        
        callerIDs[uuid] = callerName
        
        self.callProvider.reportNewIncomingCall(with: uuid, update: update) { error in
            if let error = error {
                print("Error reporting incoming call: \(error)")
            }
        }
    }

    // MARK: - Microphone Audio Session Management
    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Microphone permission granted")
            } else {
                print("Microphone permission denied")
            }
        }
    }

    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: .allowBluetooth)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }

        switch type {
        case .began:
            print("Audio session interrupted")
        case .ended:
            configureAudioSession()
            print("Audio session interruption ended")
        @unknown default:
            fatalError("Unknown interruption type")
        }
    }
    
    // MARK: - Video Management
    func startCapturingVideo() {
        guard captureSession == nil else { return }

        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high

        guard let camera = AVCaptureDevice.default(for: .video) else {
            print("No camera available")
            return
        }
        let input = try? AVCaptureDeviceInput(device: camera)
        if let input = input, captureSession?.canAddInput(input) == true {
            captureSession?.addInput(input)
        } else {
            print("Failed to add camera input")
            return
        }

        let output = AVCaptureVideoDataOutput()
        if captureSession?.canAddOutput(output) == true {
            captureSession?.addOutput(output)
        } else {
            print("Failed to add video output")
            return
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer = previewLayer

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }

    func stopCapturingVideo() {
        captureSession?.stopRunning()
        captureSession = nil
        previewLayer?.removeFromSuperlayer()
        previewLayer = nil
    }
    
    // MARK: - VoIP Registration
    func voipRegistration() {
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [.voIP]
    }
    
    // MARK: - Push Notification Settings
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                print("Push notifications authorization denied: \(String(describing: error))")
                return
            }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }

    // MARK: - Messaging Delegate Methods
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM registration token: \(String(describing: fcmToken))")
        
//        DeviceTokenManager.shared.deviceToken = deviceToken
        
        FCMTokenManager.sharedFCM.FCMTokenOfDevice = fcmToken
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        if let token = fcmToken {
            UserDefaults.standard.set(token, forKey: "fcmToken")
        }
    }
    
    // Handle incoming calls with CallKit
    func reportIncomingCall() {
        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = CXHandle(type: .phoneNumber, value: "Caller")
        
        self.callProvider.reportNewIncomingCall(with: UUID(), update: callUpdate) { error in
            if let error = error {
                print("Error reporting incoming call: \(error)")
            }
        }
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func generateFCMToken(completion: @escaping (String?) -> Void) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM token: \(error)")
                completion(nil)
            } else if let token = token {
                print("FCM token generated: \(token)")
                UserDefaults.standard.set(token, forKey: "fcmToken")
                completion(token)
            } else {
                print("FCM token is nil")
                completion(nil)
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Notification will present with userInfo: \(userInfo)")
        
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        handleNotification(notification: notification)
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Notification received with userInfo: \(userInfo)")
        
        if let messageID = userInfo["gcm.message_id"] {
            print("Message ID: \(messageID)")
        }
        
        handleNotification(notification: response.notification)
        completionHandler()
    }
    
    private func handleNotification(notification: UNNotification) {
           // Update the shared notification manager
        NotificationManager.shared.handleNotification(notification: notification)

       }
    
}

// MARK: - PKPushRegistryDelegate
extension AppDelegate: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("Push credentials updated. Device token: \(deviceToken)")
        DeviceTokenManager.shared.deviceToken = deviceToken
    }
        
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("Push token invalidated for type: \(type)")
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        let payloadDict = payload.dictionaryPayload
        
        print("Full payload: \(payloadDict)")
        
        // Extract caller info
        let callerInfo = payloadDict["callerInfo"] as? [String: Any]
        let callerName = callerInfo?["name"] as? String ?? "Unknown Caller"
        let callerID = callerInfo?["callerID"] as? String ?? "Unknown ID"
        
        // Store the callerID in OtherUserIDManager
        OtherUserIDManager.SharedOtherUID.OtherUIDOf = callerID
 
        print("Extracted caller name: \(callerName)")
        print("Extracted caller ID: \(callerID)")
        print("Stored callerID in OtherUserIDManager: \(OtherUserIDManager.SharedOtherUID.OtherUIDOf ?? "Not set")")
        
        // You can also extract other information if needed
        let videoSDKInfo = payloadDict["videoSDKInfo"] as? [String: Any]
        
        if UIApplication.shared.applicationState == .active {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Incoming Call", message: "Call from \(callerName)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.window?.rootViewController?.present(alert, animated: true)
            }
        } else {
            let content = UNMutableNotificationContent()
            content.title = "Incoming Call"
            content.body = "Call from \(callerName)"
            content.badge = NSNumber(value: 0)
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "VoIPNotification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error adding notification request: \(error)")
                }
            }
        }

        // Report incoming call with caller name and ID
        self.reportIncomingCall(callerName: callerName)
        
        completion()
    }
}

// MARK: - CXProviderDelegate
extension AppDelegate: CXProviderDelegate {
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        configureAudioSession()
        startCapturingVideo()
        
        // If this is an outgoing call, you might want to update the call here
        let update = CXCallUpdate()
        update.remoteHandle = action.handle
        update.localizedCallerName = action.handle.value
        provider.reportCall(with: action.callUUID, updated: update)
        
        NotificationCenter.default.post(name: .callAnswered, object: nil)
        NotificationCenter.default.post(name: .callAccepted, object: nil)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        configureAudioSession()
        startCapturingVideo()
        
        if let callerID = callerIDs[action.callUUID] {
            // Use the caller ID to establish the connection
            print("Establishing call connection with caller ID: \(callerID)")
            // Implement your call connection logic here
        }
        
        NotificationCenter.default.post(name: .callAnswered, object: nil)
        NotificationCenter.default.post(name: .callAccepted, object: nil)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        stopCapturingVideo()
        callerIDs.removeValue(forKey: action.callUUID)
        let meetingViewController = MeetingViewController()
        meetingViewController.meeting?.leave()
        action.fulfill()
    }
    
    func providerDidReset(_ provider: CXProvider) {
        stopCapturingVideo()
      
        callerIDs.removeAll()
    }
}


//MARK: DeviceTokenManger

class DeviceTokenManager {
    static let shared = DeviceTokenManager()
    private init() {}

    var deviceToken: String?
}


//MARK: FCMTokenManger

class FCMTokenManager{
    
    static let sharedFCM = FCMTokenManager()
    private init() {}
    
    var FCMTokenOfDevice: String?
}
