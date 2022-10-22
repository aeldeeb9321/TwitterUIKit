//
//  User.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/12/22.
//

import Foundation
import Firebase
import FirebaseAuth
//Model for our User object
struct User{
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: URL?
    let uid: String
    
    //property that will determine whether or not that user is the current user, which we will user in our ProfileHeaderViewModel
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String{
            guard let url = URL(string: profileImageUrlString) else{return}
            self.profileImageUrl = url
        }
    }
}
