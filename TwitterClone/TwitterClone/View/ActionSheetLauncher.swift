//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 1/30/23.
//

import UIKit

private let actionReuseId = "actionTvReuseId"

class ActionSheetLauncher: NSObject {
    //MARK: - Propreties
    private let user: User
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: actionReuseId)
        tv.rowHeight = 60
        tv.separatorStyle = .none
        tv.layer.cornerRadius = 5
        tv.isScrollEnabled = false
        tv.backgroundColor = .red
        return tv
    }()
    
    //we are going to be accessing the window of this application in order to show the UITableView
    private var window: UIWindow?
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        super.init()
    }
    
    //MARK: - Helpers
    func show() {
        print("DEBUG: Show action sheet for user \(user.username)")
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(dimmedView)
        dimmedView.frame = window.frame
        
        window.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 300)
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.dimmedView.alpha = 1
            self.tableView.frame.origin.y -= 300
        }
    }
    
    //MARK: - Selectors
    @objc private func handleDismissal() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.dimmedView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }

}

//MARK: - UITableViewDataSource
extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: actionReuseId, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

//MARK: - UITableViewDelegate
extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
