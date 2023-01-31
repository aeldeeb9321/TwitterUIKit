//
//  ActionSheetCell.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 1/30/23.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    //MARK: - Properties
    private let optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "twitter_logo_blue")
        iv.setDimensions(height: 36, width: 36)
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel().makebodyLabel(withText: "Test Option")
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureCellComponents() {
        addSubview(optionImageView)
        optionImageView.centerY(inView: self)
        optionImageView.anchor(left: safeAreaLayoutGuide.leftAnchor, paddingLeft: 8)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImageView.rightAnchor, paddingLeft: 12)
    }
}
