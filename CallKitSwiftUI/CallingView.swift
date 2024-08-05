//
//  CallingView.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 01/08/24.
//
//import SwiftUI
//
//struct CallingView: View {
//    var userNumber: String
//    var userName: String
//
//    @State private var isNavigating = false
//    @ObservedObject var notificationManager = NotificationManager.shared
//    
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
//                    if let callUUID = UUID(uuidString: userNumber) {
//                        CallManager.shared.endCall(callUUID: callUUID)
//                    } else {
//                        print("Invalid callUUID \(userNumber)")
//                    }
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
//        NavigationLink(
//                           destination: TryView(),
//                           isActive: $notificationManager.shouldNavigate
//                       ) {
//                           EmptyView()
//                       }
//                       .background(
//            NavigationLink(destination: CallView(callerName: userName, callerNumber: userNumber), isActive: $isNavigating) {
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
                    if let callUUID = UUID(uuidString: userNumber) {
                        CallManager.shared.endCall(callUUID: callUUID)
                    } else {
                        print("Invalid callUUID \(userNumber)")
                    }
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
            NavigationLink(destination: CallView(callerName: userName, callerNumber: userNumber), isActive: $isNavigating) {
                EmptyView()
            }
        )
        /// Navigation View After Receiving the FCM notification.
        .background(
            NavigationLink(destination: MeetingView(), isActive: $notificationManager.shouldNavigate) {
                EmptyView()
            }
        )
    }
}
