//
//  CallView.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

//import SwiftUI
//
//struct CallView: View {
//    @State private var isMicrophoneOn: Bool = true
//    @State private var isCameraOn: Bool = true
//    
//    var body: some View {
//        VStack {
//            // Camera and microphone indicators
//            HStack {
//                if isCameraOn {
//                    Image(systemName: "camera.fill")
//                        .foregroundColor(.green)
//                        .font(.largeTitle)
//                }
//                if isMicrophoneOn {
//                    Image(systemName: "mic.fill")
//                        .foregroundColor(.orange)
//                        .font(.largeTitle)
//                }
//            }
//            .padding()
//            
//            Spacer()
//            
//            // Caller's Video View (Placeholder)
//            Rectangle()
//                .foregroundColor(.black)
//                .frame(height: 300)
//                .overlay(
//                    Text("Caller Video")
//                        .foregroundColor(.white)
//                        .font(.headline)
//                )
//                .cornerRadius(10)
//                .padding()
//            
//            Spacer()
//            
//            // Call controls
//            HStack {
//                Button(action: {
//                    isMicrophoneOn.toggle()
//                }) {
//                    Image(systemName: isMicrophoneOn ? "mic.fill" : "mic.slash.fill")
//                        .font(.system(size: 24))
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(isMicrophoneOn ? Color.orange : Color.gray)
//                        .clipShape(Circle())
//                }
//                .padding(.horizontal, 20)
//                
//                Button(action: {
//                    isCameraOn.toggle()
//                }) {
//                    Image(systemName: isCameraOn ? "camera.fill" : "camera.slash.fill")
//                        .font(.system(size: 24))
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(isCameraOn ? Color.green : Color.gray)
//                        .clipShape(Circle())
//                }
//                .padding(.horizontal, 20)
//                
//                Button(action: {
//                    // End call action
//                }) {
//                    Image(systemName: "phone.down.fill")
//                        .font(.system(size: 24))
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.red)
//                        .clipShape(Circle())
//                }
//                .padding(.horizontal, 20)
//            }
//            .padding()
//        }
//        .background(Color.black.edgesIgnoringSafeArea(.all))
//    }
//}


import SwiftUI

struct CallView: View {
  @State private var isMicrophoneOn: Bool = true
  @State private var isCameraOn: Bool = true

  var callerName: String
  var callerNumber: String

    var userData = UserData()
    
  var body: some View {
    ZStack { // Use ZStack for flexible layout
      Color.black.edgesIgnoringSafeArea(.all) // Background

      VStack { // Main content stack
        // Caller Details
        HStack(alignment: .center, spacing: 10) { // Align horizontally
          Image(systemName: "person.circle.fill")
            .resizable()
            .frame(width: 50, height: 50)
            .foregroundColor(.gray)

          VStack(alignment: .leading, spacing: 5) {
            Text(callerName)
              .font(.title)
              .foregroundColor(.white)

            Text(callerNumber)
              .font(.subheadline)
              .foregroundColor(.gray)
          }
        }
        .padding(.horizontal, 30) // Padding for margins

        Spacer() // Vertical spacing

        // Placeholder for caller's video (consider using AVPlayer for live video)
        ZStack {
          Rectangle()
            .foregroundColor(.black)
            .frame(height: 300)
            .cornerRadius(10)
          
          Text("Caller Video")
            .foregroundColor(.white)
            .font(.headline)
        }
        .padding(.horizontal, 30) // Padding for margins

        Spacer() // Vertical spacing

        // Call controls
        HStack(spacing: 20) { // Distribute buttons equally
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
        }
        .padding(.horizontal, 30) // Padding for margins
      }
      .padding(.top, 30) // Padding from top
    }
    .onAppear {
        userData.UpdateCallAPI()  // Call the API when the view appears
         }
  }
}
