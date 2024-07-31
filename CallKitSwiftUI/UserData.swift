//
//  UserData.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

//import SwiftUI
//import Firebase
//import FirebaseFirestore
//
//class UserData: ObservableObject {
//    @Published var users: [User] = []
//    @Published var newName = ""
//    @Published var isEditActive = false
//    @Published var selectedUser: User? = nil // Track selected user for editing
//    @Published var callerID: String = "" // Store the caller ID
//    
//    
//    
//    private let callerIDKey = "callerIDKey" // Key for UserDefaults
//    
//    
//    
//    init() {
//        fetchData()
//    }
//    
//    func generateUniqueCallerID() -> String {
//        let randomNumber = Int.random(in: 10000...99999)
//        return String(randomNumber)
//    }
//    
//    func addData() {
//        let callerID = generateUniqueCallerID()
//        Firestore.firestore().collection("users").addDocument(data: [
//            "name": newName,
//            "callerID": callerID,
//            "deviceToken" : DeviceTokenManager.shared.deviceToken
//        ]) { [weak self] error in
//            if let error = error {
//                print("Error adding document: \(error.localizedDescription)")
//            } else {
//                print("Document added successfully")
//                self?.storeCallerID(callerID) // Store the caller ID locally
//                self?.fetchData()
//                self?.newName = "" // Clear input field after adding
//            }
//        }
//    }
//    
//    func registerUser(name: String, completion: @escaping (Bool) -> Void) {
//            let callerID = generateUniqueCallerID()
//            Firestore.firestore().collection("users").addDocument(data: [
//                "name": name,
//                "callerID": callerID,
//                "deviceToken": DeviceTokenManager.shared.deviceToken ?? "null"
//            ]) { [weak self] error in
//                if let error = error {
//                    print("Error adding document: \(error.localizedDescription)")
//                    completion(false)
//                } else {
//                    print("Document added successfully")
//                    self?.storeCallerID(callerID) // Store the caller ID locally
//                    self?.fetchData()
//                    completion(true)
//                }
//            }
//        }
//       
//    func fetchData() {
//         Firestore.firestore().collection("users").getDocuments { [weak self] snapshot, error in
//             if let error = error {
//                 print("Error fetching documents: \(error.localizedDescription)")
//             } else {
//                 if let snapshot = snapshot {
//                     self?.users = snapshot.documents.map { doc in
//                         let data = doc.data()
//                         let name = data["name"] as? String ?? ""
//                         let callerID = data["callerID"] as? String ?? ""
//                         let deviceToken = DeviceTokenManager.shared.deviceToken
//                         return User(id: doc.documentID, name: name, callerID: callerID)
//                     }
//                 }
//             }
//         }
//     }
//    
//    func updateData() {
//        guard let selectedUser = selectedUser else { return }
//        Firestore.firestore().collection("users").document(selectedUser.id).updateData(["name": newName]) { [weak self] error in
//            if let error = error {
//                print("Error updating document: \(error.localizedDescription)")
//            } else {
//                print("Document updated successfully")
//                self?.fetchData()
//                self?.newName = ""
//                self?.isEditActive.toggle() // Toggle edit mode after update
//                self?.selectedUser = nil // Deselect user after update
//            }
//        }
//    }
//    
//    func deleteData(user: User) {
//        Firestore.firestore().collection("users").document(user.id).delete() { [weak self] error in
//            if let error = error {
//                print("Error deleting document: \(error.localizedDescription)")
//            } else {
//                print("Document deleted successfully")
//                self?.fetchData() // Refetch data after deletion
//            }
//        }
//    }
//    
//    func editData(user: User) {
//        newName = user.name // Set the new name field to the current user's name
//        isEditActive = true // Activate edit mode
//        selectedUser = user // Store the selected user for updating
//    }
//
//    
//    func fetchCallerID() {
//           // Retrieve the caller ID from UserDefaults
//           if let savedCallerID = UserDefaults.standard.string(forKey: callerIDKey) {
//               self.callerID = savedCallerID
//           }
//       }
//        
//        func storeCallerID(_ callerID: String) {
//            // Save the caller ID to UserDefaults
//            UserDefaults.standard.set(callerID, forKey: callerIDKey)
//        }
//    
//
//
//    
//    // MARK: Fetching The info of user from FireStore DB Based On UserDefaults Value of Caller ID in Device
//    
//    
//    func fetchDataBasedOnCallerID() {
//        // Get callerID from UserDefaults
//        guard let callerIDDevice = fetchCallerID() else {
//            print("Caller ID not found in UserDefaults")
//            return
//        }
//        
//        // Fetch data from Firestore using callerID
//        Firestore.firestore().collection("users").document(callerIDDevice).getDocument { [weak self] document, error in
//            if let error = error {
//                print("Error fetching document: \(error.localizedDescription)")
//            } else {
//                if let document = document, document.exists {
//                    let data = document.data()
//                    let name = data?["name"] as? String ?? ""
//                    let deviceToken = data?["deviceToken"] as? String ?? ""
//                    let callerID = data?["callerID"] as? String ?? ""
//                    
//                    // Process or store the fetched data as needed
//                    self?.user = User(id: callerID, name: name, callerID: callerID, deviceToken: deviceToken)
//                } else {
//                    print("Document does not exist")
//                }
//            }
//        }
//    }
//
//    
//    
//}

import SwiftUI
import Firebase
import FirebaseFirestore

class UserData: ObservableObject {
    @Published var users: [User] = []
    @Published var newName = ""
    @Published var isEditActive = false
    @Published var selectedUser: User? = nil // Track selected user for editing
    @Published var callerID: String = "" // Store the caller ID
    @Published var otherUserID: String = "" //Store OtherUserID (Which Enter By User To make call to otherUser)
    
    private let callerIDKey = "callerIDKey" // Key for UserDefaults
    
    init() {
        fetchData()
    }
    
    func generateUniqueCallerID() -> String {
        let randomNumber = Int.random(in: 10000...99999)
        return String(randomNumber)
    }
    
    func addData() {
        let callerID = generateUniqueCallerID()
        Firestore.firestore().collection("users").addDocument(data: [
            "name": newName,
            "callerID": callerID,
            "deviceToken": DeviceTokenManager.shared.deviceToken ?? "null"
        ]) { [weak self] error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added successfully")
                self?.storeCallerID(callerID) // Store the caller ID locally
                self?.fetchData()
                self?.newName = "" // Clear input field after adding
            }
        }
    }
    
    func registerUser(name: String, completion: @escaping (Bool) -> Void) {
        let callerID = generateUniqueCallerID()
        Firestore.firestore().collection("users").addDocument(data: [
            "name": name,
            "callerID": callerID,
            "deviceToken": DeviceTokenManager.shared.deviceToken ?? "null"
        ]) { [weak self] error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Document added successfully")
                self?.storeCallerID(callerID) // Store the caller ID locally
                self?.fetchData()
                completion(true)
            }
        }
    }
    
    func fetchData() {
        Firestore.firestore().collection("users").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
            } else {
                if let snapshot = snapshot {
                    self?.users = snapshot.documents.map { doc in
                        let data = doc.data()
                        let name = data["name"] as? String ?? ""
                        let callerID = data["callerID"] as? String ?? ""
                        let deviceToken = data["deviceToken"] as? String ?? ""
                        return User(id: doc.documentID, name: name, callerID: callerID, deviceToken: deviceToken)
                    }
                }
            }
        }
    }
    
    func updateData() {
        guard let selectedUser = selectedUser else { return }
        Firestore.firestore().collection("users").document(selectedUser.id).updateData(["name": newName]) { [weak self] error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document updated successfully")
                self?.fetchData()
                self?.newName = ""
                self?.isEditActive.toggle() // Toggle edit mode after update
                self?.selectedUser = nil // Deselect user after update
            }
        }
    }
    
    func deleteData(user: User) {
        Firestore.firestore().collection("users").document(user.id).delete() { [weak self] error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                print("Document deleted successfully")
                self?.fetchData() // Refetch data after deletion
            }
        }
    }
    
    func editData(user: User) {
        newName = user.name // Set the new name field to the current user's name
        isEditActive = true // Activate edit mode
        selectedUser = user // Store the selected user for updating
    }
    
    func fetchCallerID() -> String? {
        // Retrieve the caller ID from UserDefaults
        return UserDefaults.standard.string(forKey: callerIDKey)
    }
    
    func storeCallerID(_ callerID: String) {
        // Save the caller ID to UserDefaults
        UserDefaults.standard.set(callerID, forKey: callerIDKey)
    }
    
    // MARK: Fetching Data
    
    func fetchDataBasedOnCallerID() {
        // Get callerID from UserDefaults
        guard let callerIDDevice = fetchCallerID() else {
            print("Caller ID not found in UserDefaults")
            return
        }
        
        // Fetch data from Firestore using callerID
        Firestore.firestore().collection("users").document(callerIDDevice).getDocument { [weak self] document, error in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
            } else {
                if let document = document, document.exists {
                    let data = document.data()
                    let name = data?["name"] as? String ?? ""
                    let deviceToken = data?["deviceToken"] as? String ?? ""
                    let callerID = data?["callerID"] as? String ?? ""
                    
                    // Create User instance with fetched data
                    let user = User(id: callerID, name: name, callerID: callerID, deviceToken: deviceToken)
                    self?.selectedUser = user
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    
    // MARK: For verifying the CallerID of other user which is Enter By user
    
    
//       func verifyCallerID(_ otherUserID: String, completion: @escaping (User?) -> Void) {
//           Firestore.firestore().collection("users").document(otherUserID).getDocument { document, error in
//               if let error = error {
//                   print("Error verifying caller ID: \(error.localizedDescription)")
//                   completion(nil)
//               } else {
//                   if let document = document, document.exists {
//                       let data = document.data()
//                       let name = data?["name"] as? String ?? ""
//                       let deviceToken = data?["deviceToken"] as? String ?? ""
//                       let callerID = data?["callerID"] as? String ?? ""
//                       
//                       let user = User(id: otherUserID, name: name, callerID: callerID, deviceToken: deviceToken)
//                       completion(user)
//                   } else {
//                       print(otherUserID)
//                       print("Document does not exist")
//                       completion(nil)
//                   }
//               }
//           }
//       }
    
    
    func verifyCallerID(_ otherUserID: String, completion: @escaping (User?) -> Void) {
        Firestore.firestore().collection("users")
            .whereField("callerID", isEqualTo: otherUserID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error verifying caller ID: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    if let snapshot = snapshot, !snapshot.isEmpty {
                        // Assuming callerID is unique, we take the first document
                        if let document = snapshot.documents.first {
                            let data = document.data()
                            let name = data["name"] as? String ?? ""
                            let deviceToken = data["deviceToken"] as? String ?? ""
                            let callerID = data["callerID"] as? String ?? ""
                            
                            let user = User(id: document.documentID, name: name, callerID: callerID, deviceToken: deviceToken)
                            completion(user)
                            print("The CAllerID is matched for this \(otherUserID)")
                        } else {
                            print("No document found with the given caller ID")
                            completion(nil)
                        }
                    } else {
                        print("No documents found for the given caller ID")
                        completion(nil)
                    }
                }
            }
    }
    
    
    
    
    
    
    
    
    // MARK: FETCHCALLERINFO
    
    func fetchCallerInfo(completion: @escaping (CallerInfo?) -> Void) {
        // Get callerID from UserDefaults
        guard let callerIDDevice = UserDefaults.standard.string(forKey: callerIDKey) else {
            print("Caller ID not found in UserDefaults")
            completion(nil)
            return
        }

        print("Retrieved Caller ID from UserDefaults: \(callerIDDevice)")

        // Fetch data from Firestore using the callerID field
        Firestore.firestore().collection("users")
            .whereField("callerID", isEqualTo: callerIDDevice)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    if let snapshot = snapshot, !snapshot.isEmpty {
                        // Assuming callerID is unique, we take the first document
                        if let document = snapshot.documents.first {
                            let data = document.data()
                            let name = data["name"] as? String ?? ""
                            let deviceToken = data["deviceToken"] as? String ?? ""
                            let callerID = data["callerID"] as? String ?? ""

                            let callerInfo = CallerInfo(id: document.documentID, name: name, callerID: callerID, deviceToken: deviceToken)
                            completion(callerInfo)
                           
                        } else {
                            print("No document found with the given caller ID")
                            completion(nil)
                        }
                    } else {
                        print("No documents found for the given caller ID")
                        completion(nil)
                    }
                }
            }
    }


    
    
    // MARK: FETCH CALLEEEINFO
    
    func fetchCalleeInfo(callerID: String, completion: @escaping (CalleeInfo?) -> Void) {
        // Fetch data from Firestore using the callerID field
        Firestore.firestore().collection("users")
            .whereField("callerID", isEqualTo: callerID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    if let snapshot = snapshot, !snapshot.isEmpty {
                        // Assuming callerID is unique, we take the first document
                        if let document = snapshot.documents.first {
                            let data = document.data()
                            let name = data["name"] as? String ?? ""
                            let deviceToken = data["deviceToken"] as? String ?? ""
                            let callerID = data["callerID"] as? String ?? ""

                            let calleeInfo = CalleeInfo(id: document.documentID, name: name, callerID: callerID, deviceToken: deviceToken)
                            completion(calleeInfo)
                          
                        } else {
                            print("No document found with the given caller ID")
                            completion(nil)
                        }
                    } else {
                        print("No documents found for the given caller ID")
                        completion(nil)
                    }
                }
            }
    }

    
    
//    func initiateCall(otherUserID: String) {
//        fetchCallerInfo { [weak self] callerInfo in
//            guard let callerInfo = callerInfo else {
//                print("Error fetching caller info")
//                return
//            }
//    
//            self?.fetchCalleeInfo(callerID: otherUserID) { calleeInfo in
//                guard let calleeInfo = calleeInfo else {
//                    print("Error fetching callee info")
//                    return
//                }
//    
//                // Use callerInfo and calleeInfo as needed
//                print("Caller Info: \(callerInfo)")
//                print("Callee Info: \(calleeInfo)")
//            }
//        }
//    }
    
    
    
//    func initiateCall(otherUserID: String, completion: @escaping (CallerInfo?, CalleeInfo?, VideoSDKInfo?) -> Void) {
//        fetchCallerInfo { callerInfo in
//            guard let callerInfo = callerInfo else {
//                print("Error fetching caller info")
//                completion(nil, nil, nil)
//                return
//            }
//            
//            self.fetchCalleeInfo(callerID: otherUserID) { calleeInfo in
//                guard let calleeInfo = calleeInfo else {
//                    print("Error fetching callee info")
//                    completion(nil, nil, nil)
//                    return
//                }
//                
//                // Use callerInfo and calleeInfo as needed
//                let videoSDKInfo = VideoSDKInfo()
//                completion(callerInfo, calleeInfo, videoSDKInfo)
//            }
//        }
//        
//    }
    
    
    func initiateCall(otherUserID: String, completion: @escaping (CallerInfo?, CalleeInfo?, VideoSDKInfo?) -> Void) {
        fetchCallerInfo { callerInfo in
            guard let callerInfo = callerInfo else {
                print("Error fetching caller info")
                completion(nil, nil, nil)
                return
            }

            self.fetchCalleeInfo(callerID: otherUserID) { calleeInfo in
                guard let calleeInfo = calleeInfo else {
                    print("Error fetching callee info")
                    completion(nil, nil, nil)
                    return
                }

                // Use callerInfo and calleeInfo as needed
                let videoSDKInfo = VideoSDKInfo() // Initialize as needed
                completion(callerInfo, calleeInfo, videoSDKInfo)

                // Create a CallRequest
                let callRequest = CallRequest(callerInfo: callerInfo, calleeInfo: calleeInfo, videoSDKInfo: videoSDKInfo)
                self.sendCallRequest(callRequest) { result in
                    switch result {
                    case .success(let data):
                        // Handle successful response
                        print("Call request successful: \(String(describing: data))")
                    case .failure(let error):
                        // Handle error
                        print("Error sending call request: \(error)")
                    }
                }
            }
        }
    }

    // MARK: API

    public func sendCallRequest(_ request: CallRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        guard let url = URL(string: "http://192.168.22.132:3000/initiate-call") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completion(.success(data))
                } else {
                    let error = NSError(domain: "API Error", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                    completion(.failure(error))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }

    
    
    
    
}
