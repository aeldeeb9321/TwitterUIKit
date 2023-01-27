//
//  UploadTweetController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/12/22.
//

import UIKit

class UploadTweetController: UIViewController{
    
    //MARK: - Properties
    private let user: User
    
    private lazy var actionButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .twtrBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        //for oval shape the corner radius is height / 2. for a circle the height and width need to be the same
        button.layer.cornerRadius = 32 / 3
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: 48, width: 48)
        iv.layer.cornerRadius = 24
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let captionTextView = CaptionTextView()
    
    //MARK: - Lifecycle
    //we are initializing user and it is being passed in from our main tab controller, that way we can load the user image without having to do an unnecessary api call. We know this controller needs info on the user which is why we initialized it.
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else{return}
        TweetService.shared.uploadTweet(caption: caption) { error, ref in
            if let error = error{
                print("Debug: Failed to upload tweet with error \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
    //MARK: - API
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureNavBar()
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView,captionTextView])
        stackView.axis = .horizontal
        stackView.spacing = 12
        view.addSubview(stackView)
        
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
    }
    
    func configureNavBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}
