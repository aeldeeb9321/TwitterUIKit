//
//  ProfileFilterCell.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/18/22.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var option: ProfileFilterOptions? {
        didSet{
            guard let option = option else { return }
            titleLabel.text = option.description
        }
    }
    let titleLabel: UILabel = {
        let label = UILabel().uiLabel(withText: "Test filter",font: UIFont.systemFont(ofSize: 14), textColor: .lightGray)
        return label
    }()
    
    override var isSelected: Bool {
        //if the cell if selected we want to make the font bigger and change the color
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16): UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twtrBlue: .lightGray
        }
    }
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
