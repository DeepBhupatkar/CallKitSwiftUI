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
    @State private var otherUserID: String = ""
    @State private var isCallViewActive: Bool = false
    @State private var isNewUser: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // Display User's Caller ID
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Caller ID")
                        .font(.headline)
                        .foregroundColor(.white)

                    HStack(spacing: 10) {
                        Text(userData.callerID)
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

                Spacer()

                // Enter Call ID Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Enter call ID of another user")
                        .font(.headline)
                        .foregroundColor(.white)

                    TextField("Enter ID", text: $otherUserID)
                        .foregroundColor(.black)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }
                .padding()
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                .cornerRadius(12)

                Spacer()

                // Call Now Button
                NavigationLink(destination: CallView(), isActive: $isCallViewActive) {
                    Button(action: {
                        // Call Now button action
                        isCallViewActive = true
                    }) {
                        Text("Call Now")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                Spacer()
                
                
                NavigationLink(destination: RegistrationView(), isActive: $isNewUser) {
                    Button(action: {
                        // Call Now button action
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
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.05, green: 0.05, blue: 0.05))
            .edgesIgnoringSafeArea(.all) // Make the view full screen
            .onAppear {
                userData.fetchCallerID() // Fetch caller ID on appear
            }
        }
    }
}

