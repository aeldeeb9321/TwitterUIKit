//
//  FeedController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/6/22.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"
class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    var user: User? {
        didSet{
            configureUserUI()
        }
    }
    
    private var tweets = [Tweet]() {
        //we did this since it takes time for our api call to retrieve the tweets array, our collectionView numberOfItemsInSection returns tweets.count but it starts at 0 since it loads before the api call. So when our tweets array is set we will reload the data in our collectionView
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    private func fetchTweets() {
        TweetService.shared.fetchTweets { tweets in
            print("Debug: Tweets are \(tweets)")
            print("Debug number of tweets is \(tweets.count)")
            //since we created a class level variable we can now recieve this fetched tweets array and store it in our class var
            self.tweets = tweets
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(height: 44, width: 44)
        navigationItem.titleView = imageView
    }
    private func configureUserUI() {
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

//MARK: - UICollectionViewDelegate/DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedTweet = tweets[indexPath.row]
        let controller = TweetController(tweet: selectedTweet)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
//MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.item]
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 70)
    }
}

//MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { error, ref in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
        }
        
        if let tweet = cell.tweet {
            print("DEBUG: Tweet is liked is \(tweet.didLike)")
        }
        
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        //this will initialize our profile controller with the user that is associated with that tweet
        guard let user = cell.tweet?.user else{return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
