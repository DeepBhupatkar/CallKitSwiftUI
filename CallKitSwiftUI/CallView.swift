//
//  CallView.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

import SwiftUI

struct CallView: View {
    @State private var isMicrophoneOn: Bool = true
    @State private var isCameraOn: Bool = true
    
    var body: some View {
        VStack {
            // Camera and microphone indicators
            HStack {
                if isCameraOn {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.green)
                        .font(.largeTitle)
                }
                if isMicrophoneOn {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.orange)
                        .font(.largeTitle)
                }
            }
            .padding()
            
            Spacer()
            
            // Caller's Video View (Placeholder)
            Rectangle()
                .foregroundColor(.black)
                .frame(height: 300)
                .overlay(
                    Text("Caller Video")
                        .foregroundColor(.white)
                        .font(.headline)
                )
                .cornerRadius(10)
                .padding()
            
            Spacer()
            
            // Call controls
            HStack {
                Button(action: {
                    isMicrophoneOn.toggle()
                }) {
                    Image(systemName: isMicrophoneOn ? "mic.fill" : "mic.slash.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(isMicrophoneOn ? Color.orange : Color.gray)
                        .clipShape(Circle())
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    isCameraOn.toggle()
                }) {
                    Image(systemName: isCameraOn ? "camera.fill" : "camera.slash.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(isCameraOn ? Color.green : Color.gray)
                        .clipShape(Circle())
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    // End call action
                }) {
                    Image(systemName: "phone.down.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                }
                .padding(.horizontal, 20)
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
