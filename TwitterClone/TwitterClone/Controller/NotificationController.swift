//
//  NotificationController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/6/22.
//

import UIKit

class NotificationController: UIViewController {
    //MARK: - Properties
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }
}

