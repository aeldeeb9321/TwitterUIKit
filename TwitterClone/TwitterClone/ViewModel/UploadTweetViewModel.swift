//
//  UploadTweetViewModel.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 1/29/23.
//

import UIKit

enum UploadTweetConfiguration {
    case tweet
    //tweet is an associated value for reply since every reply is associated with a new tweet
    case reply(Tweet)
}

struct UploadTweetViewModel {
    let actionButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyText: String?
    init(config: UploadTweetConfiguration) {
        switch config {
        case .tweet:
            actionButtonTitle = "Tweet"
            placeholderText = "What's happening?"
            shouldShowReplyLabel = false
            replyText = nil
        case .reply(let tweet):
            actionButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyText = "Replying to @\(tweet.user.username)"
        }
    }
}
