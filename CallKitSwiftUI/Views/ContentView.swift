//
//  ContentView.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//


import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    @StateObject private var userData = UserData() // Fetch user data
    @State public var otherUserID: String = "" // Use this to set the ID to verify
    @State private var isCallViewActive: Bool = false // REMOVE
    @State private var isNewUser: Bool = false // REMOVE
    @State private var isLoading: Bool = true // REMOVE
    @State private var isCallingViewActive: Bool = false
    @State private var userName: String = "" // REMOVE
    @State private var userNumber: String = ""
    
    @State private var callerName: String = "null"
    @State private var callerNumber: String = "null"
    
    
    @State private var callAccepted: Bool = false
    
    
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

                Spacer()

                // Enter Call ID Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Enter call ID of another user")
                        .font(.headline)
                        .foregroundColor(.white)

                    TextField("Enter ID", text: $otherUserID)
                        .keyboardType(.numberPad)
                        .foregroundColor(.black)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding()
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                .cornerRadius(12)

                Spacer()
               
                Button("Verify Caller ID") {
                    userData.verifyCallerID(otherUserID) { user in
                        if let user = user {
                            print("User details: \(user)")
                            // Handle successful verification, e.g., update UI or navigate to another view
                        } else {
                            print("User not found")
                            // Handle case where user is not found
                        }
                    }
                }
                
                Button("Start Call") {
                    
                           
                    // Replace with the actual otherUserID you want to initiate the call with
                    userData.initiateCall(otherUserID: otherUserID) { callerInfo, calleeInfo, videoSDKInfo in
                        // Pass the user's name and number to the calling view
                        self.userName = calleeInfo?.name ?? "null"
                        self.userNumber = calleeInfo?.callerID ?? "null"
                       
                        self.callerName = callerInfo?.name ?? "null"
                        self.callerNumber = callerInfo?.callerID ?? "null"
                             
                       
                        
                        
                        self.isCallingViewActive = true
                        NotificationCenter.default.post(name: .callingStarted, object: nil) // Post the notification here
                        
                        
                    }
                }                
                Spacer()

                // Add New User Button
                NavigationLink(destination: RegistrationView(), isActive: $isNewUser) {
                    Button(action: {
                        // Navigate to registration view
                        isNewUser = true
                    }) {
                        Text("Add New User")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
               
                
                
                NavigationLink(destination: MeetingView(), isActive: $isCallViewActive) {
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


