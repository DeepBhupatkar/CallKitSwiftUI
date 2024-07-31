//
//  InitiateCallInfo.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 31/07/24.
//

import Foundation





// USER A : the user who Initiate the call to other user (USER B)
struct CallerInfo: Identifiable {
    let id: String
    let name: String
    let callerID: String
    let deviceToken : String

}


// USER B : the user who going to recive call from (USER A)
struct CalleeInfo: Identifiable {
    let id: String
    let name: String
    let callerID: String
    let deviceToken : String

}







//Meeting Info Can Be Static
struct VideoSDKInfo: Identifiable {
    let id: String
    let name: String
    let callerID: String
    let deviceToken : String

}


