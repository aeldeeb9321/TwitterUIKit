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
    
    func fetchUser(completion: @escaping(User) -> Void){
        //if we recognize a user is logged in we get back info about that current user's id
        guard let uid = Auth.auth().currentUser?.uid else{return}
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else{return}
            //Created a customer user object and used the data that we got from our database to construct that object
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
}
