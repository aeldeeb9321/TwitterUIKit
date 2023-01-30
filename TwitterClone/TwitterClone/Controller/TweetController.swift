//
//  TweetController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 1/28/23.
//

import UIKit

private let tweetReuseId = "tweetControllerId"
private let tweetHeaderId = "tweetHeaderId"

class TweetController: UICollectionViewController {
    //MARK: - Properties
    private let tweet: Tweet
    
    private lazy var actionSheetLauncher: ActionSheetLauncher = {
        let launcher = ActionSheetLauncher(user: tweet.user)
        return launcher
    }()
    
    //MARK: - Init
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        print("DEBUG:Tweet caption is \(tweet.caption)")
    }
    
    
    //MARK: - Helpers
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: tweetReuseId)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: tweetHeaderId)
    }
    
    //MARK: - Selectors
    
}

//MARK: - CollectionView DataSource/Delegate Methods
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: tweetHeaderId, for: indexPath) as! TweetHeader
        view.tweet = tweet
        view.delegate = self
        return view
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tweetReuseId, for: indexPath) as! TweetCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: captionHeight + 265)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 125)
    }
}

//MARK: - TweetHeaderDelegate
extension TweetController: TweetHeaderDelegate {
    func showActionSheet() {
        actionSheetLauncher.show()
    }
    
    
}
