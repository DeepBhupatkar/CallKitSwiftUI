//
//  RegistrationView.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

//import SwiftUI
//import Firebase
//import FirebaseFirestore
//
//struct RegistrationView: View {
//    @StateObject private var userData = UserData() // Manage user data
//    @State private var newName: String = "" // New user's name
//    @State private var isUserRegistered: Bool = false // Flag for registration success
//
//    var body: some View {
//        VStack(spacing: 50) {
//            
//            Spacer()
//            
//            Text("Register New User")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding()
//                .foregroundColor(Color.white)
//
//            // Enter User Name
//            TextField("Enter your name", text: $newName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            // Register Button
//            Button(action: {
//                userData.registerUser(name: newName)
//                isUserRegistered = true
//            }) {
//                Text("Register")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .cornerRadius(12)
//            }
//            .padding(.horizontal)
//
//            // Success Message
//            if isUserRegistered {
//                Text("User registered successfully!")
//                    .font(.headline)
//                    .foregroundColor(.blue)
//            }
//
//            Spacer()
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.black)
//        .edgesIgnoringSafeArea(.all)
//    }
//}

import SwiftUI
import Firebase
import FirebaseFirestore

struct RegistrationView: View {
    @StateObject private var userData = UserData() // Manage user data
    @State private var newName: String = "" // New user's name
    @State private var isUserRegistered: Bool = false // Flag for registration success

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Register New User")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(Color.white)

            // Enter User Name
            TextField("Enter your name", text: $newName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            // Register Button
            Button(action: {
                userData.registerUser(name: newName) { success in
                    if success {
                        isUserRegistered = true
                        newName = "" // Clear text field
                    } else {
                        isUserRegistered = false
                    }
                }
            }) {
                Text("Register")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            // Success Message
            if isUserRegistered {
                Text("User registered successfully!")
                    .font(.headline)
                    .foregroundColor(.blue)
            }

            // User List
            List(userData.users) { user in
                HStack {
                    Text(user.name)
                        .foregroundColor(.white)
                    Spacer()
                    Text(user.callerID)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            userData.fetchData() // Fetch user data when the view appears
        }
    }
}
