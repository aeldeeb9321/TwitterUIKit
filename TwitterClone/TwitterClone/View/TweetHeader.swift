//
//  TweetHeader.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 1/28/23.
//

import UIKit

protocol TweetHeaderDelegate: AnyObject {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    weak var delegate: TweetHeaderDelegate?
    
    var tweet: Tweet? {
        didSet {
            configureHeader()
        }
    }
    
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
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton()
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        return button
    }()
    
    private let retweetsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        view.setDimensions(height: 30, width: 0)
        let divider1 = UIView()
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        divider1.anchor(top: view.topAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, paddingLeft: 8, height: 1)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let divider2 = UIView()
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        divider2.anchor(top: view.bottomAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, paddingLeft: 8, height: 1)
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCreateCommentForTweet), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureReusableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureHeader() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        fullnameLabel.text = viewModel.fullnameText
        usernameLabel.text = viewModel.usernameText
        dateLabel.text = viewModel.headerTimeStamp
        likesLabel.attributedText = viewModel.likesAttributedString
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
    
    private func configureReusableView() {
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -4
        
        let userStack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        userStack.spacing = 12
        
        addSubview(userStack)
        userStack.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: userStack.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, paddingTop: 20, paddingLeft: 16)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 12)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.spacing = 72
        actionStack.distribution = .fillEqually
        
        addSubview(actionStack)
        actionStack.centerX(inView: self)
        actionStack.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 12)
        
        addSubview(optionsButton)
        optionsButton.centerY(inView: userStack)
        optionsButton.anchor(right: safeAreaLayoutGuide.rightAnchor, paddingRight: 12)
    }
    
    private func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton().makeButton(withImage: UIImage(named: imageName)?.withTintColor(.darkGray), isRounded: false)
        button.setDimensions(height: 20, width: 20)
        return button
    }
    
    //MARK: - Selectors
    
    @objc private func handleProfileImageTapped() {
        //handle profile image tapped delegate method
        print("DEBUG: Go to user profile..")
    }
    
    @objc private func showActionSheet() {
        print("DEBUG: Handle show action sheet..")
        delegate?.showActionSheet()
    }
    
    @objc private func handleCreateCommentForTweet() {
        print("DEBUG: Handle add comment to tweet..")
    }
    
    @objc private func handleRetweetTapped() {
        print("DEBUG: Retweet tweet..")
    }
    
    @objc private func handleLikeButtonTapped() {
        print("DEBUG: Add like to tweet..")
    }
    
    @objc private func handleShareButtonTapped() {
        print("DEBUG: Shared tweet..")
    }
}
