//
//  AppDelegate.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 31/07/24.
//

//import UIKit
//import PushKit
//import CallKit
//import UserNotifications
//import FirebaseCore
//
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    
//    var window: UIWindow?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        self.registerForPushNotifications()
//        self.voipRegistration()
//        FirebaseApp.configure()
//        return true
//    }
//    
//    // Register for VoIP notifications
//    func voipRegistration() {
//        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
//        voipRegistry.delegate = self
//        voipRegistry.desiredPushTypes = [PKPushType.voIP]
//    }
//    
//    // Push notification setting
//    func getNotificationSettings() {
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().getNotificationSettings { settings in
//                UNUserNotificationCenter.current().delegate = self
//                if settings.authorizationStatus == .authorized {
//                    DispatchQueue.main.async {
//                        UIApplication.shared.registerForRemoteNotifications()
//                    }
//                }
//            }
//        } else {
//            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//    }
//    
//    // Register push notification
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                self.getNotificationSettings()
//            } else {
//                print("Push notifications authorization denied: \(String(describing: error))")
//            }
//        }
//    }
//}
//
//// MARK: - UNUserNotificationCenterDelegate
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        print("Notification received with userInfo: \(userInfo)")
//        completionHandler()
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        print("Notification will present with userInfo: \(userInfo)")
//        completionHandler([.alert, .sound, .badge])
//    }
//}
//
//// MARK: - PKPushRegistryDelegate
//extension AppDelegate: PKPushRegistryDelegate {
//    
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
//        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
//        print("Push credentials updated. Device token: \(deviceToken)")
//    }
//        
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
//        print("Push token invalidated for type: \(type)")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//        let payloadDict = payload.dictionaryPayload["aps"] as? [String: Any] ?? [:]
//        let message = payloadDict["alert"] as? String ?? "No message"
//        
//        if UIApplication.shared.applicationState == .active {
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "VoIP Notification", message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                self.window?.rootViewController?.present(alert, animated: true)
//            }
//        } else {
//            let content = UNMutableNotificationContent()
//            content.title = "VoIP Notification"
//            content.body = message
//            content.badge = NSNumber(value: 0)
//            content.sound = .default
//                
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let request = UNNotificationRequest(identifier: "VoIPNotification", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//        }
//        
//        completion()
//    }
//}

//
//import UIKit
//import PushKit
//import CallKit
//import UserNotifications
//import AVFoundation
//import FirebaseCore
//import Firebase
//import FirebaseMessaging
//
//
//class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
//    
//    var window: UIWindow?
//    var callObserver: CXCallObserver!
//    var callController: CXCallController!
//    var callProvider: CXProvider!
//    
//    // Video capture properties
//    private var captureSession: AVCaptureSession?
//    private var previewLayer: AVCaptureVideoPreviewLayer?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        
//        UIApplication.shared.applicationIconBadgeNumber = 0
//        
//        FirebaseApp.configure()
//        
//        // Initialize CallKit components
//        self.callObserver = CXCallObserver()
//        self.callController = CXCallController()
//        self.callProvider = CXProvider(configuration: CXProviderConfiguration(localizedName: "In VideoSDK Callkit Demo"))
//        self.callProvider.setDelegate(self, queue: nil)
//        
//        self.registerForPushNotifications()
//        self.voipRegistration()
//        
//        
//        Messaging.messaging().delegate = self
//        
//        self.requestMicrophonePermission()
//        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
//        
//        return true
//    }
//    
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(fcmToken)")
//
//    }
//    
//    
//    // MARK: - Microphone Audio Session Management
//    func requestMicrophonePermission() {
//        AVAudioSession.sharedInstance().requestRecordPermission { granted in
//            if granted {
//                print("Microphone permission granted")
//            } else {
//                print("Microphone permission denied")
//            }
//        }
//    }
//
//    func configureAudioSession() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: .allowBluetooth)
//            try audioSession.setActive(true)
//        } catch {
//            print("Failed to set up audio session: \(error)")
//        }
//    }
//    
//    @objc func handleInterruption(notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
//              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
//            return
//        }
//
//        switch type {
//        case .began:
//            print("Audio session interrupted")
//        case .ended:
//            configureAudioSession()
//            print("Audio session interruption ended")
//        @unknown default:
//            fatalError("Unknown interruption type")
//        }
//    }
//    
//    // MARK: - Video Management
//    func startCapturingVideo() {
//        guard captureSession == nil else { return }
//
//        captureSession = AVCaptureSession()
//        captureSession?.sessionPreset = .high
//
//        guard let camera = AVCaptureDevice.default(for: .video) else {
//            print("No camera available")
//            return
//        }
//        let input = try? AVCaptureDeviceInput(device: camera)
//        if let input = input, captureSession?.canAddInput(input) == true {
//            captureSession?.addInput(input)
//        } else {
//            print("Failed to add camera input")
//            return
//        }
//
//        let output = AVCaptureVideoDataOutput()
//        if captureSession?.canAddOutput(output) == true {
//            captureSession?.addOutput(output)
//        } else {
//            print("Failed to add video output")
//            return
//        }
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//        previewLayer.videoGravity = .resizeAspectFill
//        self.previewLayer = previewLayer
//
//        // Perform startRunning on a background thread
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.captureSession?.startRunning()
//        }
//    }
//
//    func stopCapturingVideo() {
//        captureSession?.stopRunning()
//        captureSession = nil
//        previewLayer?.removeFromSuperlayer()
//        previewLayer = nil
//    }
//    
//    // MARK: - VoIP Registration
//    func voipRegistration() {
//        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
//        voipRegistry.delegate = self
//        voipRegistry.desiredPushTypes = [.voIP]
//    }
//    
//    // MARK: - Push Notification Settings
//    func getNotificationSettings() {
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().getNotificationSettings { settings in
//                UNUserNotificationCenter.current().delegate = self
//                if settings.authorizationStatus == .authorized {
//                    DispatchQueue.main.async {
//                        UIApplication.shared.registerForRemoteNotifications()
//                    }
//                }
//            }
//        } else {
//            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//    }
//    
//    // Register push notifications
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                self.getNotificationSettings()
//            } else {
//                print("Push notifications authorization denied: \(String(describing: error))")
//            }
//        }
//    }
//    
//    // Handle incoming calls with CallKit
//    func reportIncomingCall() {
//        let callUpdate = CXCallUpdate()
//        callUpdate.remoteHandle = CXHandle(type: .phoneNumber, value: "Caller")
//        
//        self.callProvider.reportNewIncomingCall(with: UUID(), update: callUpdate) { error in
//            if let error = error {
//                print("Error reporting incoming call: \(error)")
//            }
//        }
//    }
//    
//    // MARK: - UISceneSession Lifecycle
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//    }
//    
//    // MARK: - Notification Handling
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
//    }
//}
//
//
//
////extension AppDelegate : MessagingDelegate {
////    // [START refresh_token]
////    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
////        print("Firebase registration token: \\(fcmToken)")
////        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
////    }
////}
//
//
//
//
//
//// MARK: - UNUserNotificationCenterDelegate
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        print("Notification received with userInfo: \(userInfo)")
//        completionHandler()
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        print("Notification will present with userInfo: \(userInfo)")
//        completionHandler([.alert, .sound, .badge])
//    }
//}
//
//// MARK: - PKPushRegistryDelegate
//extension AppDelegate: PKPushRegistryDelegate {
//    
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
//        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
//        print("Push credentials updated. Device token: \(deviceToken)")
//        DeviceTokenManager.shared.deviceToken = deviceToken
//    }
//        
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
//        print("Push token invalidated for type: \(type)")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//        let payloadDict = payload.dictionaryPayload["aps"] as? [String: Any] ?? [:]
//        let message = payloadDict["alert"] as? String ?? "No message"
//        
//        if UIApplication.shared.applicationState == .active {
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "VoIP Notification", message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                self.window?.rootViewController?.present(alert, animated: true)
//            }
//        } else {
//            // Schedule a local notification for background or closed state
//            let content = UNMutableNotificationContent()
//            content.title = "VoIP Notification"
//            content.body = message
//            content.badge = NSNumber(value: 0)
//            content.sound = .default
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let request = UNNotificationRequest(identifier: "VoIPNotification", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request) { error in
//                if let error = error {
//                    print("Error adding notification request: \(error)")
//                }
//            }
//        }
//
//        // Report the incoming call using CallKit
//        self.reportIncomingCall()
//        
//        completion()
//    }
//}
//
//// MARK: - CXProviderDelegate
//extension AppDelegate: CXProviderDelegate {
//    
//    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
//        configureAudioSession()
//        startCapturingVideo() // Start video capture when starting a call
//        NotificationCenter.default.post(name: .callingStarted, object: nil)
//        action.fulfill()
//    }
//
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        configureAudioSession()
//        startCapturingVideo() // Start video capture when answering a call
//        NotificationCenter.default.post(name: .callAnswered, object: nil)
//        NotificationCenter.default.post(name: .callAccepted, object: nil)
//        action.fulfill()
//    }
//
//    
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        stopCapturingVideo() // Stop video capture when ending a call
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setActive(false)
//        } catch {
//            print("Failed to deactivate audio session: \(error)")
//        }
//        action.fulfill()
//    }
//    
//    func providerDidReset(_ provider: CXProvider) {
//        stopCapturingVideo() // Stop video capture on provider reset
//    }
//}
//
//    
//    
//

//
//
//import UIKit
//import PushKit
//import CallKit
//import UserNotifications
//import AVFoundation
//import FirebaseCore
//
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    
//    var window: UIWindow?
//    var callObserver: CXCallObserver!
//    var callController: CXCallController!
//    var callProvider: CXProvider!
//    
//    // Video capture properties
//    private var captureSession: AVCaptureSession?
//    private var previewLayer: AVCaptureVideoPreviewLayer?
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        
//        UIApplication.shared.applicationIconBadgeNumber = 0
//        
//        FirebaseApp.configure()
//        
//        // Initialize CallKit components
//        self.callObserver = CXCallObserver()
//        self.callController = CXCallController()
//        self.callProvider = CXProvider(configuration: CXProviderConfiguration(localizedName: "In VideoSDK Callkit Demo"))
//        self.callProvider.setDelegate(self, queue: nil)
//        
//        self.registerForPushNotifications()
//        self.voipRegistration()
//    
//        
//        self.requestMicrophonePermission()
//        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
//        
//        return true
//    }
//    
//  
//    
//    // MARK: - Microphone Audio Session Management
//    func requestMicrophonePermission() {
//        AVAudioSession.sharedInstance().requestRecordPermission { granted in
//            if granted {
//                print("Microphone permission granted")
//            } else {
//                print("Microphone permission denied")
//            }
//        }
//    }
//
//    func configureAudioSession() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: .allowBluetooth)
//            try audioSession.setActive(true)
//        } catch {
//            print("Failed to set up audio session: \(error)")
//        }
//    }
//    
//    @objc func handleInterruption(notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
//              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
//            return
//        }
//
//        switch type {
//        case .began:
//            print("Audio session interrupted")
//        case .ended:
//            configureAudioSession()
//            print("Audio session interruption ended")
//        @unknown default:
//            fatalError("Unknown interruption type")
//        }
//    }
//    
//    // MARK: - Video Management
//    func startCapturingVideo() {
//        guard captureSession == nil else { return }
//
//        captureSession = AVCaptureSession()
//        captureSession?.sessionPreset = .high
//
//        guard let camera = AVCaptureDevice.default(for: .video) else {
//            print("No camera available")
//            return
//        }
//        let input = try? AVCaptureDeviceInput(device: camera)
//        if let input = input, captureSession?.canAddInput(input) == true {
//            captureSession?.addInput(input)
//        } else {
//            print("Failed to add camera input")
//            return
//        }
//
//        let output = AVCaptureVideoDataOutput()
//        if captureSession?.canAddOutput(output) == true {
//            captureSession?.addOutput(output)
//        } else {
//            print("Failed to add video output")
//            return
//        }
//
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
//        previewLayer.videoGravity = .resizeAspectFill
//        self.previewLayer = previewLayer
//
//        // Perform startRunning on a background thread
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.captureSession?.startRunning()
//        }
//    }
//
//    func stopCapturingVideo() {
//        captureSession?.stopRunning()
//        captureSession = nil
//        previewLayer?.removeFromSuperlayer()
//        previewLayer = nil
//    }
//    
//    // MARK: - VoIP Registration
//    func voipRegistration() {
//        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
//        voipRegistry.delegate = self
//        voipRegistry.desiredPushTypes = [.voIP]
//    }
//    
//    // MARK: - Push Notification Settings
//    func getNotificationSettings() {
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().getNotificationSettings { settings in
//                UNUserNotificationCenter.current().delegate = self
//                if settings.authorizationStatus == .authorized {
//                    DispatchQueue.main.async {
//                        UIApplication.shared.registerForRemoteNotifications()
//                    }
//                }
//            }
//        } else {
//            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
//            UIApplication.shared.registerUserNotificationSettings(settings)
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//    }
//    
//    // Register push notifications
//    func registerForPushNotifications() {
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                self.getNotificationSettings()
//            } else {
//                print("Push notifications authorization denied: \(String(describing: error))")
//            }
//        }
//    }
//    
//    // Handle incoming calls with CallKit
//    func reportIncomingCall() {
//        let callUpdate = CXCallUpdate()
//        callUpdate.remoteHandle = CXHandle(type: .phoneNumber, value: "Caller")
//        
//        self.callProvider.reportNewIncomingCall(with: UUID(), update: callUpdate) { error in
//            if let error = error {
//                print("Error reporting incoming call: \(error)")
//            }
//        }
//    }
//    
//    // MARK: - UISceneSession Lifecycle
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//    }
//    
//    // MARK: - Notification Handling
//    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
//    }
//}
//
//// MARK: - UNUserNotificationCenterDelegate
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        print("Notification received with userInfo: \(userInfo)")
//        completionHandler()
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        print("Notification will present with userInfo: \(userInfo)")
//        completionHandler([.alert, .sound, .badge])
//    }
//}
//
//// MARK: - PKPushRegistryDelegate
//extension AppDelegate: PKPushRegistryDelegate {
//    
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
//        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
//        print("Push credentials updated. Device token: \(deviceToken)")
//        DeviceTokenManager.shared.deviceToken = deviceToken
//    }
//        
//    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
//        print("Push token invalidated for type: \(type)")
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
//        let payloadDict = payload.dictionaryPayload["aps"] as? [String: Any] ?? [:]
//        let message = payloadDict["alert"] as? String ?? "No message"
//        
//        if UIApplication.shared.applicationState == .active {
//            DispatchQueue.main.async {
//                let alert = UIAlertController(title: "VoIP Notification", message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default))
//                self.window?.rootViewController?.present(alert, animated: true)
//            }
//        } else {
//            // Schedule a local notification for background or closed state
//            let content = UNMutableNotificationContent()
//            content.title = "VoIP Notification"
//            content.body = message
//            content.badge = NSNumber(value: 0)
//            content.sound = .default
//
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//            let request = UNNotificationRequest(identifier: "VoIPNotification", content: content, trigger: trigger)
//            UNUserNotificationCenter.current().add(request) { error in
//                if let error = error {
//                    print("Error adding notification request: \(error)")
//                }
//            }
//        }
//
//        // Report the incoming call using CallKit
//        self.reportIncomingCall()
//        
//        completion()
//    }
//}
//
//// MARK: - CXProviderDelegate
//extension AppDelegate: CXProviderDelegate {
//    
//    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
//        configureAudioSession()
//        startCapturingVideo() // Start capturing video on call start
//        action.fulfill()
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        configureAudioSession()
//        startCapturingVideo() // Start capturing video on call answer
//        action.fulfill()
//    }
//    
//    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        stopCapturingVideo() // Stop capturing video on call end
//        action.fulfill()
//    }
//    
//    func providerDidReset(_ provider: CXProvider) {
//        stopCapturingVideo()
//    }
//}


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
        let payloadDict = payload.dictionaryPayload["aps"] as? [String: Any] ?? [:]
        let message = payloadDict["alert"] as? String ?? "No message"
        
        if UIApplication.shared.applicationState == .active {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "VoIP Notification", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.window?.rootViewController?.present(alert, animated: true)
            }
        } else {
            let content = UNMutableNotificationContent()
            content.title = "VoIP Notification"
            content.body = message
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

        self.reportIncomingCall()
        
        completion()
    }
}

// MARK: - CXProviderDelegate
extension AppDelegate: CXProviderDelegate {
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        configureAudioSession()
        startCapturingVideo()
        NotificationCenter.default.post(name: .callAnswered, object: nil)
        NotificationCenter.default.post(name: .callAccepted, object: nil)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        configureAudioSession()
        startCapturingVideo()
        NotificationCenter.default.post(name: .callAnswered, object: nil)
        NotificationCenter.default.post(name: .callAccepted, object: nil)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        stopCapturingVideo()
        action.fulfill()
    }
    
    func providerDidReset(_ provider: CXProvider) {
        stopCapturingVideo()
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
