//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/6/22.
//

import UIKit
import Firebase
import FirebaseAuth

class MainTabController: UITabBarController {
    //MARK: - Properties
    //This button will show up on every tabBar
    lazy var actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.twtrBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twtrBlue
        //logUserOut()
        authenticateUserAndConfigureUI()

    }
    
    //MARK: - API
    //Any controller that requires user information can be configured with that info from this mainTabBarcontroller
    func fetchUser(){
        UserService.shared.fetchUser()
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
        let feedVC = FeedController()
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
        print(123)
    }

}
