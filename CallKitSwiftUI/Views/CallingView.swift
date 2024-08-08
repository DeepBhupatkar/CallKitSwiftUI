//
//  CallingView.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

//import SwiftUI
//
//struct CallingView: View {
//    var userNumber: String
//    var userName: String
//
//    @State private var isNavigating = false
//    @ObservedObject var notificationManager = NotificationManager.shared
//    @EnvironmentObject var meetingIDManager: MeetingIDManager
//
//    var body: some View {
//        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all)
//
//            VStack(spacing: 30) {
//                HStack(alignment: .center) {
//                    Image(systemName: "person.circle.fill")
//                        .resizable()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.gray)
//
//                    VStack(alignment: .leading, spacing: 5) {
//                        Text(userName)
//                            .font(.largeTitle)
//                            .foregroundColor(.white)
//
//                        Text(userNumber)
//                            .font(.title)
//                            .foregroundColor(.white)
//                    }
//                }
//
//                Spacer()
//
//                Text("Calling...")
//                    .font(.title2)
//                    .foregroundColor(.gray)
//
//                Spacer()
//
//                Button(action: {
//                 
//                }) {
//                    Image(systemName: "phone.down.fill")
//                        .font(.system(size: 24))
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.red)
//                        .clipShape(Circle())
//                }
//                .padding(.bottom, 50)
//            }
//            .padding(.horizontal, 30)
//        }
//        /// Navigation View After Receiving the FCM notification.
//        .background(
//            NavigationLink(destination: MeetingView(meetingId:meetingIDManager.meetingID), isActive: $notificationManager.shouldNavigate) {
//                EmptyView()
//            }
//        )
//    }
//}

import SwiftUI

struct CallingView: View {
    var userNumber: String
    var userName: String

    @State private var isNavigating = false
    @ObservedObject var notificationManager = NotificationManager.shared


    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                HStack(alignment: .center) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)

                    VStack(alignment: .leading, spacing: 5) {
                        Text(userName)
                            .font(.largeTitle)
                            .foregroundColor(.white)

                        Text(userNumber)
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }

                Spacer()

                Text("Calling...")
                    .font(.title2)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: {
              
                }) {
                    Image(systemName: "phone.down.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Circle())
                }
                .padding(.bottom, 50)
            }
            .padding(.horizontal, 30)
        }
        .background(
            NavigationLink(destination: MeetingView(meetingId: MeetingManager.shared.currentMeetingID ?? ""), isActive: $notificationManager.shouldNavigate) {
                EmptyView()
            }
        )
    }
    
    

    
}
