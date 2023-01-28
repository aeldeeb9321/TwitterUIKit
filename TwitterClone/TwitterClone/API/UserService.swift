//
//  UserService.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/11/22.
//

import Firebase
import FirebaseAuth

//THis typealias will help us avoid keep rewriting the escaping arguments
typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService{
    static let shared = UserService()
    
    func fetchUser(uid: String,completion: @escaping(User) -> Void) {
//        //if we recognize a user is logged in we get back info about that current user's id
//        guard let uid = Auth.auth().currentUser?.uid else{return}
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else{return}
            //Created a customer user object and used the data that we got from our database to construct that object
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    func fetchUsers (completion: @escaping([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else{return}
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else{return}
        //update child values
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid : 1]) { error, ref in
            //then update the second structure
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid : 1], withCompletionBlock: completion)
        }
//        print("DEBUG: Current uid \(currentUid) started following \(uid)")
//        print("DEBUG: Uid \(uid) gained \(currentUid) as a follower")
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else{return}
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { err, ref in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> ()) {
        //we are just going to have a completion of a boolean variable since all we need to do is check if a value exists in the structure. So to check and see if we are following somone we go into the user-following structure and see if the uid exists. If it does then we completed this with true, if it doesnt we complete it with false. THen we will update our ui based on the value of the completion block.
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            //snapshot.exists will tell us whether or not that child we are looking for exists
            print("DEBUG: User is followed is \(snapshot.exists())")
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserInfoStats) -> ()) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                let stats = UserInfoStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
}
