//
//  Constants.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/9/22.
//

import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

//creating shorthand global constants that allow us to access our database information
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user_tweets")
