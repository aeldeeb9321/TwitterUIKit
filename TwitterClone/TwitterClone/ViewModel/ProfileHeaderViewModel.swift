//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/19/22.
//

import UIKit

enum ProfileFilterOptions: Int,CaseIterable{
    //since we conformed to the Int property all the case get an int value which starts at 0. Since our cv cells are define as 0,1,2, this will help us map each case to our corresponding collection view cells
    case tweets
    case replies
    case likes
    case media
    var description: String {
        switch self{
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"
        case .media:
            return "Media"
        }
    }
}

struct ProfileHeaderViewModel{
    private let user: User
    init(user: User){
        self.user = user
    }
    
    func attributedText(withValue value: Int, text: String) -> NSAttributedString{
        let attributedTitle = NSMutableAttributedString(string: "\(value)", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: text, attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
}
