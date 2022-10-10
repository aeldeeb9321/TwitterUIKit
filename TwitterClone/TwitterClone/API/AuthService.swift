//
//  AuthService.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/9/22.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

//making a structure like this is more professional than making a bunch of parameters in our AuthService method so its isnt messy
struct AuthCredentials{
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService{
    static let shared = AuthService()
    
    func registerUser(credentials: AuthCredentials, completion:  @escaping(Error?, DatabaseReference) -> Void){
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        let profileImage = credentials.profileImage
        //convert profile image from its current state into a data object
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else{return}
        //now that we have the imageData we need to make a unique filename for our data
        let filename = NSUUID().uuidString
        
        //creating a storage reference
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename) //(where we want to put our data)
        //upload that data into the database
        storageRef.putData(imageData) { meta, error in
            //how to get download url
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else{return}
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error{
                        print("Debug: Error is \(error.localizedDescription)")
                        return
                    }
                    guard let uid = result?.user.uid else{return}
                    //dictionary of values that we will upload to firebase when our user is successfully created
                    let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageUrl]
                    
                    //accessing info in our google info.plist using our api key and the database url. We are using the plist to access the data we need to create the url and read/write data to it. Its a cloud based database
                    //we make the users child and then another struct w uid
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }
}
