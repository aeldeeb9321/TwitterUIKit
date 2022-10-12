//
//  UserService.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/11/22.
//

import Firebase
import FirebaseAuth

struct UserService{
    static let shared = UserService()
    
    func fetchUser(){
        //if we recognize a user is logged in we get back info about that current user's id
        guard let uid = Auth.auth().currentUser?.uid else{return}
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            print("Debug: Snapshot is \(snapshot)")
            guard let dictionary = snapshot.value as? [String: AnyObject] else{return}
            print("Debug: Dictionary is \(dictionary)")
            
            //parsing through our dictionary with the key "username" and getting the value
            guard let username = dictionary["username"] as? String else{return}
            print("Debug: Username is \(username)")
        }
    }
}
