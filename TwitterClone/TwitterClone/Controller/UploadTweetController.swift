//
//  UploadTweetController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/12/22.
//

import UIKit

class UploadTweetController: UIViewController{
    
    //MARK: - Properties
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
    //MARK: - Lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    @objc func handleCancel(){
        dismiss(animated: true)
    }
    
    @objc func handleUploadTweet(){
        print("Debug: Upload tweet here...")
    }
    //MARK: - API
    
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}
