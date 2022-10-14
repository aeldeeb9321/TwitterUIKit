//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/6/22.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseRemoteConfigSwift
class MainTabController: UITabBarController {
    //MARK: - Properties
    
    var user: User?{
        //Passing this user from the tabController to the feedController once our user gets set in fetchUser()
        didSet{
            guard let nav = viewControllers?[0] as? UINavigationController else{return}
            guard let feed = nav.viewControllers.first as? FeedController else{return}
            feed.user = user
        }
    }
    //This button will show up on every tabBar
    lazy var actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        var remoteColor: UIColor{
            if AbTest.shared.remoteConfig.configValue(forKey: "backgroundColor", source: RemoteConfigSource.remote).stringValue == "treatment"{
                return .orange
            }else{
                return .green
            }
        }
        button.backgroundColor = remoteColor
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twtrBlue
        AbTest.shared.remoteConfig.fetch { status, error in
            if status == .success {
                print("Config fetched!")
                AbTest.shared.remoteConfig.activate { changed, error in
                  // ...
                }
              } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
              }
            print("DebugRemote: \(AbTest.shared.remoteConfig.allKeys(from: .remote))")
            
        }
        
        //logUserOut()
        authenticateUserAndConfigureUI()

    }
    
    //MARK: - API
    //Any controller that requires user information can be configured with that info from this mainTabBarcontroller
    func fetchUser(){
        //thanks to the completion block we now have access to the user. Since its in a completion block our code doesnt get executed until our user is fetched. We stated in the completion block that we wanted User type in the completion, we have access to that user when we call this function following execution of completion
        UserService.shared.fetchUser { user in
            //setting the user
            self.user = user
            print("Main tab user is \(user.username)")
        }
    }
    func authenticateUserAndConfigureUI(){
        if Auth.auth().currentUser == nil{
            //present them to the login Controller
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }else{
            configureViewControllers()
            setupTabBar()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut(){
        do{
            try Auth.auth().signOut()
            print("Debug: Did log user out")
        }catch let error{
            print("Debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 56, paddingRight: 16)
        actionButton.setDimensions(height: 56, width: 56)
        actionButton.layer.cornerRadius = 28 //divide the height or width by 2 to get circular shape
    }

    func configureViewControllers(){
        let feedVC = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let feedNC = templateNavigationController(image: "home_unselected", rootViewController: feedVC)
        
        let exploreVC = ExploreController()
        let exploreNC = templateNavigationController(image: "search_unselected", rootViewController: exploreVC)
       
        let notificationsVC = NotificationController()
        let notificationsNC = templateNavigationController(image: "like_unselected", rootViewController: notificationsVC)
        
        let conversationsVC = ConversationsController()
        let conversationsNC = templateNavigationController(image: "mail", rootViewController: conversationsVC)
        
        //An array of the root view controllers displayed by the tab bar interface.
        viewControllers = [feedNC, exploreNC, notificationsNC, conversationsNC]
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .black
        tabBar.backgroundColor = .systemGroupedBackground
        //tabBar.isTranslucent = false
    }
    
    func templateNavigationController(image: String, rootViewController: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = UIImage(named: image)
        nav.navigationBar.barTintColor = .white
        return nav
    }
    
    //MARK: - Selectors
    
    @objc func actionButtonTapped(sender: UIButton){
        guard let user = user else{return}
        let nav = UINavigationController(rootViewController: UploadTweetController(user: user))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

}
