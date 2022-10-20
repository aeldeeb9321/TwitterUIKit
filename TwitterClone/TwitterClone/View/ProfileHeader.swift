//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/16/22.
//

import UIKit

class ProfileHeader: UICollectionReusableView{
    
    //MARK: - Properties
    
    private let filterBar = ProfileFilterView()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twtrBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor,left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(height: 30, width: 30)
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twtrBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twtrBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Flora"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "@flowergirl"
        return label
    }()
    
    private let bioLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "This is a user bio that will span more than one line for testing purposes."
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twtrBlue
        return view
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Following"
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        //added the gesture recognizer so we can so the user's followers when tapped
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "2 Followers"
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        //added the gesture recognizer so we can so the user is followering when tapped
        return label
    }()
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        filterBar.delegate = self
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 100)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor,paddingTop: -24, paddingLeft: 8)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 40
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingRight: 12)
        editProfileFollowButton.setDimensions(height: 36, width: 100)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        userDetailStack.axis = .vertical
        //resizes arranged subview so it fills available space
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        addSubview(userDetailStack)
        userDetailStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8,paddingLeft: 12, paddingRight: 12)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        addSubview(followStack)
        followStack.anchor(top: userDetailStack.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        let cellCount = CGFloat(ProfileFilterOptions.allCases.count)
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, height: 2, width: frame.width / cellCount)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Selectors
    @objc func handleDismissal(){
        
    }
    
    @objc func handleEditProfileFollow(){
        
    }
    
    @objc func handleFollowersTapped(){
        
    }
    
    @objc func handleFollowingTapped(){
        
    }
}
//MARK: - ProfileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate{
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        //getting the cell for the corresponding indexPath
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else{return}
        //get the xposition of that cell
        let xPosition = cell.frame.origin.x
        //animate our underline view to that xposition
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
    
    
}
