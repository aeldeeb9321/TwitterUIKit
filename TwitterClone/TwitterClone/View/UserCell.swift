//
//  UserCell.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/25/22.
//

import UIKit

class UserCell: UITableViewCell {
    
    //MARK: - Properties
    
    var user: User? {
        didSet{
            configure()
        }
    }
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: 40, width: 40)
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        iv.backgroundColor = .twtrBlue
    
        return iv
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Username"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Fullname"
        return label
    }()
    
    //MARK: - LifeCycle
    
    //how you initialize a uitableviewcell programmatically
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let nameStack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        nameStack.axis = .vertical
        nameStack.spacing = 3
        nameStack.distribution = .fillProportionally
        addSubview(nameStack)
        nameStack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let user = user else {
            return
        }
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullname
    }
}
