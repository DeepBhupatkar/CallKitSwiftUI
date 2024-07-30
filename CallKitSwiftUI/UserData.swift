//
//  UserData.swift
//  CallKitSwiftUI
//
//  Created by Deep Bhupatkar on 30/07/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class UserData: ObservableObject {
    @Published var users: [User] = []
    @Published var newName = ""
    @Published var isEditActive = false
    @Published var selectedUser: User? = nil // Track selected user for editing
    @Published var callerID: String = "" // Store the caller ID
    
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
            "callerID": callerID
        ]) { [weak self] error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("Document added successfully")
                self?.fetchData()
                self?.newName = "" // Clear input field after adding
            }
        }
    }
    
    func registerUser(name: String, completion: @escaping (Bool) -> Void) {
           let callerID = generateUniqueCallerID()
           Firestore.firestore().collection("users").addDocument(data: [
               "name": name,
               "callerID": callerID
           ]) { [weak self] error in
               if let error = error {
                   print("Error adding document: \(error.localizedDescription)")
                   completion(false)
               } else {
                   print("Document added successfully")
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
                           return User(id: doc.documentID, name: name, callerID: callerID)
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
    
    
    
    // Function to fetch caller ID (You need to implement the logic to get the caller ID from Firebase)
    func fetchCallerID() {
        // Example of fetching caller ID (You should replace it with your actual data fetching logic)
        Firestore.firestore().collection("users").document("umgImKpCgHXMV2ekcxQq").getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.callerID = data?["callerID"] as? String ?? "Unknown"
            } else {
                print("Document does not exist")
            }
        }
    }


}
