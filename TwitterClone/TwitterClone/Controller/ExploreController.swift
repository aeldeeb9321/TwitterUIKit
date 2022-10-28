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
    
    private var filteredUsers = [User]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    //help us determine whether the user is typing something or not
    private var inSearchMode: Bool{
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    private func fetchUsers(){
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    //MARK: - Helpers
    private func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        //removing serpator lines
        tableView.separatorColor = .none
    }
    
    private func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user.."
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

extension ExploreController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count: users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row]: users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row]: users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ExploreController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        //we will use this to update controller with filter text user types in, called every time you enter or delete something from search bar
        guard let searchText = searchController.searchBar.text?.lowercased() else{return}
        filteredUsers = users.filter({ $0.username.lowercased().contains(searchText) || $0.fullname.lowercased().contains(searchText)})
    }
    
}
