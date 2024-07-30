//
//  ContentView.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var callerID: String = "40230"
    @State private var otherUserID: String = ""
    @State private var isCallViewActive: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                // Caller ID Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Caller ID")
                        .font(.headline)
                        .foregroundColor(.white)

                    HStack(spacing: 10) {
                        Text(callerID)
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
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.05, green: 0.05, blue: 0.05))
            .edgesIgnoringSafeArea(.all) // Make the view full screen
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
