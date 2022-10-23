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
        //ref references the tweet structure in our database
        let ref = REF_TWEETS.childByAutoId() //we stored this property in ref so we can get access to the key that it creates
        //automatically generates uid and then uploads all information
        ref.updateChildValues(values) { error, ref in
            //update our user-tweet structure after tweet upload completes
            guard let tweetID = ref.key else{return}
            REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
        }
    }
    //fetching the tweets from our database, used the info we got back from the database to construct our custom tweet object by passing in the tweetid and dictionary. Within that dictionary we look for the values we need to populate the properties in our Tweet structure.
    func fetchTweets(completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        //.childAdded is a dataEventType which monitors for when a new child is added to a location. It has a looping functionality where it iterates through each one of the elements of a structure in the database and gives us back the information about that
        REF_TWEETS.observe(.childAdded) { snapshot  in
            guard let dictionary = snapshot.value as? [String: Any] else{return}
            guard let uid = dictionary["uid"] as? String else{return}
            //the key for each snapshot which we need to construct our tweet
            let tweetId = snapshot.key
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetId, dictionary: dictionary)
                tweets.insert(tweet, at: 0)
                completion(tweets)
            }
            
        }
    }
    
    func fetchTweets(forUser user: User, completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        //we want this function to give us back an array of tweets which we will use to populate the user profile controller with that array of tweets (our datasource for the controller)
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            //With the tweet ids, we go back into the tweet structure. Find the tweet ids, and get all of the tweet data
            let tweetID = snapshot.key
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                //now we are getting the snapshot of each tweet which will give us the caption, likes, retweets, timestamp and uid of user
                print(snapshot)
                
                guard let dictionary = snapshot.value as? [String: Any] else{return}
                guard let uid = dictionary["uid"] as? String else{return}
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                    tweets.insert(tweet, at: 0)
                    completion(tweets)
                }
            }
        }
    }
}
