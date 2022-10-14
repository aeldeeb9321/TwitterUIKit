//
//  TweetService.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/13/22.
//

import Foundation
import Firebase
import FirebaseDatabase

struct TweetService{
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void){
        //We need the uid since we need to know who made a tweet
        guard let uid = Auth.auth().currentUser?.uid else{return}
        //values that we will upload to our database
        let values = ["uid": uid, "timestamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweets": 0, "caption": caption] as [String : Any]
        //automatically generates uid and then uploads all information
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
}
