//
//  ProfileController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/16/22.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"
class ProfileController: UICollectionViewController{
    
    //MARK: - Properties
    //our profile is associated with a user
    private let user: User
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //making the nav bar style white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - API
    func fetchTweets(){
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
    }
    //MARK: - Helpers
    
    func configureCollectionView(){
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
extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

extension ProfileController{
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
}

extension ProfileController: ProfileHeaderDelegate{
    func handleDissmisal() {
        navigationController?.popViewController(animated: true)
    }
}
