//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/19/22.
//

import UIKit

enum ProfileFilterOptions: Int,CaseIterable {
    //since we conformed to the Int property all the case get an int value which starts at 0. Since our cv cells are define as 0,1,2, this will help us map each case to our corresponding collection view cells
    case tweets
    case replies
    case likes

    var description: String {
        switch self{
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"

        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User
    
    let usernameText: String
    
    init(user: User){
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    var followersText: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingText: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var actionButtonTitle: String {
    
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        } else if user.isFollowed && !user.isCurrentUser {
            return "Following"
        } else {
            return "Edit Profile"
        }
    }
    //we made it fileprivate since its just a helper function
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value) ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: text, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
