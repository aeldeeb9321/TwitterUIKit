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
    //fetching the tweets from our database, used the info we got back from the database to construct our custom tweet object by passing in the tweetid and dictionary. Within that dictionary we look for the values we need to populate the properties in our Tweet structure.
    func fetchTweets(completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        //.childAdded is a dataEventType which monitors for when a new child is added to a location. It has a looping functionality where it iterates through each one of the elements of a structure in the database and gives us back the information about that
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else{return}
            //the key for each snapshot which we need to construct our tweet
            let tweetId = snapshot.key
            let tweet = Tweet(tweetID: tweetId, dictionary: dictionary)
            tweets.append(tweet)
            completion(tweets)
        }
    }
}
