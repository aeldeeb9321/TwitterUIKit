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
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
        configureSearchController()
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
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
}

extension ExploreController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        //we will use this to update controller with filter text user types in, called every time you enter or delete something
        print("DEBUG: Seatch text is \(searchController.searchBar.text)")
    }
    
}
