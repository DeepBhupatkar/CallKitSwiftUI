//
//  ContentView.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct JoinView: View {
    @StateObject private var userData = UserData() 
    @State public var otherUserID: String = ""
    @State private var isCallViewActive: Bool = false
    @State private var isLoading: Bool = true
    @State private var isCallingViewActive: Bool = false
    @State private var userName: String = ""
    @State private var userNumber: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                if isLoading {
                    // Display loading animation
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5, anchor: .center)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                } else {
                    // Display User's Caller ID
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Caller ID")
                            .font(.headline)
                            .foregroundColor(.white)

                        HStack(spacing: 10) {
                            Text(userData.fetchCallerID() ?? "null")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .cornerRadius(12)
                }

                Spacer(minLength: 2)

                // Enter Call ID Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Enter call ID of another user")
                        .font(.headline)
                        .foregroundColor(.white)

                    TextField("Enter ID", text: $otherUserID)
//                        .keyboardType(.numberPad)
                        .foregroundColor(.black)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding()
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                .cornerRadius(12)

              Spacer(minLength: 2)
               
                Button(action: {
                    userData.initiateCall(otherUserID: otherUserID) { callerInfo, calleeInfo, videoSDKInfo in
                        // Post the notification here
                        self.isCallingViewActive = true
                        NotificationCenter.default.post(name: .callingStarted, object: nil) 
                        
                        // Pass the user's name and number to the calling view
                        self.userName = calleeInfo?.name ?? "null"
                        self.userNumber = calleeInfo?.callerID ?? "null"

                    }
                }) {
                    HStack {
                        Text("Start Call")
                        Image(systemName: "phone.circle.fill")
                            .imageScale(.large)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.trailing)
                Spacer()

                NavigationLink(destination: MeetingView(meetingId:MeetingManager.shared.currentMeetingID), isActive: $isCallViewActive) {
                    EmptyView()
                }

                NavigationLink(destination: CallingView(userNumber: userNumber, userName: userName), isActive: $isCallingViewActive) {
                    EmptyView()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.05, green: 0.05, blue: 0.05))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                userData.fetchCallerID() // Fetch caller ID on appear
                isLoading = false
                NotificationCenter.default.addObserver(forName: .callAnswered, object: nil, queue: .main) { _ in
                    self.isCallViewActive = true
                }
                NotificationCenter.default.addObserver(forName: .callingStarted, object: nil, queue: .main) { _ in
                    self.isCallingViewActive = true
                }
            }
        }
    }
}
