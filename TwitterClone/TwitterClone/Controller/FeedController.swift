//
//  FeedController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/6/22.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"
class FeedController: UICollectionViewController{
    //MARK: - Properties
    var user: User?{
        didSet{
            configureUserUI()
        }
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    //MARK: - API
    
    func fetchTweets(){
        TweetService.shared.fetchTweets { tweets in
            print("Debug: Tweets are \(tweets)")
        }
    }
    
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        //collectionView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellWithReuseIdentifier: <#T##String#>)
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(height: 44, width: 44)
        navigationItem.titleView = imageView
    }
    func configureUserUI(){
        guard let user = user else{return}
        let profileImageView = UIImageView()
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.sd_setImage(with: user.profileImageUrl)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
    }
}

extension FeedController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
}
