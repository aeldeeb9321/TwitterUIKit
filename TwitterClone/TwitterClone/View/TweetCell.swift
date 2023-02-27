//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/13/22.
//

import UIKit

//delegating action from tweetcell to controller
protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
}
class TweetCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var tweet: Tweet? {
        didSet{
            configure()
        }
    }
    
    weak var delegate: TweetCellDelegate?
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: 48, width: 48)
        iv.layer.cornerRadius = 24
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twtrBlue
        
        //we are implementing an action handler to a view property through a gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        //by default this is set to false so you need to set it to true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Some text caption"
        return label
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton().tweetButton(imageName: "comment", selector: #selector(handleCommentTapped))
        return button
    }()
    
    private let retweetButton: UIButton = {
        let button = UIButton().tweetButton(imageName: "retweet", selector: #selector(handleRetweetTappped))
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton().tweetButton(imageName: "like", selector: #selector(handleLikeTapped))
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton().tweetButton(imageName: "share", selector: #selector(handleShareTapped))
        return button
    }()
    private let infoLabel = UILabel()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,paddingTop: 8, paddingLeft: 8)
        
        let stack = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillProportionally
        infoLabel.text = "Flora @flowergirl"
        infoLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(stack)
        stack.anchor(top:profileImageView.topAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        actionStack.spacing = 72
        addSubview(actionStack)
        actionStack.anchor(bottom: bottomAnchor, paddingBottom: 8)
        actionStack.centerX(inView: self)
        
        let divider = UIView()
        divider.backgroundColor = .systemGroupedBackground
        addSubview(divider)
        divider.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc private func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }
    
    @objc private func handleRetweetTappped() {
        
    }
    
    @objc private func handleLikeTapped() {
        
    }
    
    @objc private func handleShareTapped() {
        
    }
    
    @objc private func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
        
    }
    
    //MARK: - Helpers
    
    private func configure() {
        guard let tweet = tweet else{return}
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        infoLabel.attributedText = viewModel.userInfoText
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
