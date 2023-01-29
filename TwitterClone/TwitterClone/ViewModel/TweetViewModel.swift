//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/15/22.
//

import UIKit

struct TweetViewModel {
    //MARK: - Properties
    let tweet: Tweet
    
    let user: User
    
    var profileImageUrl: URL?{
        return user.profileImageUrl
    }
    
    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
    }
    
    var headerTimeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ・ MM/dd//yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: "@\(user.username)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: "・ \(timeStamp)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var fullnameText: String {
        return user.fullname
    }
    
    var retweetsAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    //MARK: - Init
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    //MARK: - Helpers
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value) ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: text, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
    
    //We are going to be passing in some text and figuring out the size or frame of the text and then specify a width when we call this function so we can accurately determine the size of our label
    func size(forWidth width: CGFloat) -> CGSize {
        //measurement label
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        //lineBreakMode is a technique to use for wrapping and truncating the label's text.
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        //returns the optimal size of the view based on its current constraints
        let size = measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size
    }
    
}
