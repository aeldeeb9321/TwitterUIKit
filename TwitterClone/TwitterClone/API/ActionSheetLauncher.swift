//
//  ActionSheetLauncher.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 1/30/23.
//

import UIKit

private let actionReuseId = "actionTvReuseId"

protocol ActionSheetLauncherDelegate: AnyObject {
    func didSelect(option: ActionSheetOptions)
}

class ActionSheetLauncher: NSObject {
    //MARK: - Propreties
    private let user: User
    
    weak var delegate: ActionSheetLauncherDelegate?
    
    //we are going to be accessing the window of this application in order to show the UITableView
    private var window: UIWindow?
    
    private lazy var viewModel = ActionSheetViewModel(user: user)
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(ActionSheetCell.self, forCellReuseIdentifier: actionReuseId)
        tv.rowHeight = 60
        tv.separatorStyle = .none
        tv.layer.cornerRadius = 5
        tv.isScrollEnabled = false
        return tv
    }()
    
    private var tableViewHeight: CGFloat?
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissal))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.centerY(inView: view)
        cancelButton.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton().makeButton(withTitle: "Cancel", titleColor: .label, buttonColor: .systemGroupedBackground, isRounded: true)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Init
    init(user: User) {
        self.user = user
        super.init()
    }
    
    //MARK: - Helpers
    
    private func showtableView(_ shouldShow: Bool) {
        guard let window = window else { return }
        guard let height = tableViewHeight else { return }
        let y = shouldShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = y
    }
    
    func show() {
        print("DEBUG: Show action sheet for user \(user.username)")
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(dimmedView)
        dimmedView.frame = window.frame
        
        window.addSubview(tableView)
        let height = CGFloat(viewModel.options.count * 60) + 100
        self.tableViewHeight = height
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.dimmedView.alpha = 1
            self.showtableView(true)
        }
    }
    
    //MARK: - Selectors
    
    @objc private func handleDismissal() {
        UIView.animate(withDuration: 0.5, delay: 0) {
            self.dimmedView.alpha = 0
            self.tableView.frame.origin.y += 280
        }
    }

}

//MARK: - UITableViewDataSource

extension ActionSheetLauncher: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: actionReuseId, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
}

//MARK: - UITableViewDelegate

extension ActionSheetLauncher: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = viewModel.options[indexPath.row]
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.dimmedView.alpha = 0
            self.showtableView(false)
        } completion: { _ in
            self.delegate?.didSelect(option: option)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
}
