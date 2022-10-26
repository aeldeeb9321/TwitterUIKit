//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/6/22.
//

import UIKit
private let reuseIdentifier = "reuseIdentifier"
class ExploreController: UITableViewController{
    //MARK: - Properties
    private var users = [User](){
        didSet{
            tableView.reloadData()
        }
    }
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
    }
    
    //MARK: - API
    private func fetchUsers(){
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    //MARK: - Helpers
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        //removing serpator lines
        tableView.separatorColor = .none
    }
}

extension ExploreController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        return cell
    }
}
