//
//  ProfileController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/16/22.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"
class ProfileController: UICollectionViewController {
    
    //MARK: - Properties
    //our profile is associated with a user
    private var user: User {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet{
            collectionView.reloadData()
        }
    }
    //MARK: - LifeCycle
    init(user: User) {
        self.user = user
        //Since its a collection viewController we have to call super.init
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
        checkIfUserIsFollowed()
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //making the nav bar style white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - API
    private func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
    }
    
    private func checkIfUserIsFollowed() {
        UserService.shared.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
        }
    }
    
    private func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            print("Debug: User has \(stats.followers) followers")
            print("Debug: User is following \(stats.following) people")
            self.user.stats = stats
        }
    }
    //MARK: - Helpers
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        //The behavior for determining the adjusted content offsets for the header
        collectionView.contentInsetAdjustmentBehavior = .never
        //Prior to calling the dequeueReusableCell(withReuseIdentifier:for:) method of the collection view, you must use this .register method to tell the collection view how to create a new cell of the given type.
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        //registering header
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    //MARK: - Selectors
    
}

//MARK: - UICollectionViewDataSource
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
}

extension ProfileController: ProfileHeaderDelegate{
    func handleEditProfileFollow(_ header: ProfileHeader) {
        print("DEBUG: User is followed is \(user.isFollowed) prior to button tap")
        // we need added a bool to our User Model so when we follow the user we set the property to true and when we unfollow its set to false
        if user.isCurrentUser {
            print("DEBUG: Show edit profile Controller..")
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { err, ref in
                self.user.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { ref, error in
                self.user.isFollowed = true
            }
        }
    }
    
    func handleDissmisal() {
        navigationController?.popViewController(animated: true)
    }
}
