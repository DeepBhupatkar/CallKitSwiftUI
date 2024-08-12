//
//  MeetingView.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 02/08/24.
//

import SwiftUI
import VideoSDKRTC
import WebRTC

struct MeetingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var meetingViewController = MeetingViewController()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var meetingId: String?
    @State var userName: String? = "Demo"
    @State var isUnMute: Bool = true
    @State var camEnabled: Bool = true
    @State var isScreenShare: Bool = false
    @State var isCallActive: Bool = true  // State to track if the call is active
    
    var userData = UserData()
    
    var body: some View {
        
        VStack {
            if meetingViewController.participants.isEmpty {
                Text("Meeting Initializing")
            } else {
                VStack {
                    VStack(spacing: 20) {
                        Text("Meeting ID: \(MeetingManager.shared.currentMeetingID!)")
                            .padding(.vertical)
                        
                        List {
                            ForEach(meetingViewController.participants.indices, id: \.self) { index in
                                Text("Participant Name: \(meetingViewController.participants[index].displayName)")
                                ZStack {
                                    ParticipantView(track: meetingViewController.participants[index].streams.first(where: { $1.kind == .state(value: .video) })?.value.track as? RTCVideoTrack).frame(height: 250)
                                    if meetingViewController.participants[index].streams.first(where: { $1.kind == .state(value: .video) }) == nil {
                                        Color.white.opacity(1.0).frame(width: UIScreen.main.bounds.width, height: 250)
                                        Text("No media")
                                    }
                                }
                            }
                        }
                    }
                    
                    VStack {
                        HStack(spacing: 15) {
                            // Mic button
                            Button {
                                isUnMute.toggle()
                                if isUnMute {
                                    meetingViewController.meeting?.unmuteMic()
                                } else {
                                    meetingViewController.meeting?.muteMic()
                                }
                            } label: {
                                Text("Toggle Mic")
                                    .foregroundStyle(Color.white)
                                    .font(.caption)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.blue))
                            }
                            
                            // Camera button
                            Button {
                                camEnabled.toggle()
                                if camEnabled {
                                    meetingViewController.meeting?.enableWebcam()
                                } else {
                                    meetingViewController.meeting?.disableWebcam()
                                }
                            } label: {
                                Text("Toggle WebCam")
                                    .foregroundStyle(Color.white)
                                    .font(.caption)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.blue))
                            }
                        }
                        
                        HStack {
                            // Screen share button
                            Button {
                                isScreenShare.toggle()
                                if isScreenShare {
                                    Task {
                                        await meetingViewController.meeting?.enableScreenShare()
                                    }
                                } else {
                                    Task {
                                        await meetingViewController.meeting?.disableScreenShare()
                                    }
                                }
                            } label: {
                                Text("Toggle ScreenShare")
                                    .foregroundStyle(Color.white)
                                    .font(.caption)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.blue))
                            }
                            
                            // End meeting button
                            Button {
                                DispatchQueue.main.async {
                                     endCallFromSwiftUI()
                                 }
                            } label: {
                                Text("End Call")
                                    .foregroundStyle(Color.white)
                                    .font(.caption)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(Color.red))
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
        .onAppear {
            // Configure VideoSDK and join/create meeting
            VideoSDK.config(token: meetingViewController.token)
            if let meetingId = meetingId, !meetingId.isEmpty {
                meetingViewController.joinMeeting(meetingId: meetingId, userName: userName ?? "Unknown")
            }
        }
    }
    
    // Function to end call and handle necessary cleanup
    func endCallFromSwiftUI() {
        print("Calling endCall from SwiftUI")
//        DispatchQueue.main.async {
            guard isCallActive else {
                print("No active call to end")
                return
            }
            meetingViewController.meeting?.end()
            appDelegate.endCall()  // Call AppDelegate method to end the call
            isCallActive = false   // Set call state to inactive
            presentationMode.wrappedValue.dismiss()
//        }
    }
}


/// VideoView for participant's video
class VideoView: UIView {
    
    var videoView: RTCMTLVideoView = {
        let view = RTCMTLVideoView()
        view.videoContentMode = .scaleAspectFill
        view.backgroundColor = UIColor.black
        view.clipsToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        
        return view
    }()
    
    init(track: RTCVideoTrack?) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250))
        backgroundColor = .clear
        DispatchQueue.main.async {
            self.addSubview(self.videoView)
            self.bringSubviewToFront(self.videoView)
            track?.add(self.videoView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// ParticipantView for showing and hiding VideoView
struct ParticipantView: UIViewRepresentable {
    var track: RTCVideoTrack?
    
    func makeUIView(context: Context) -> VideoView {
        let view = VideoView(track: track)
        view.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        return view
    }
    
    func updateUIView(_ uiView: VideoView, context: Context) {
        if track != nil {
            track?.add(uiView.videoView)
        } else {
            track?.remove(uiView.videoView)
        }
    }
}
