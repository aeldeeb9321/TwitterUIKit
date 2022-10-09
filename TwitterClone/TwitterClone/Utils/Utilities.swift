//
//  Utilities.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/8/22.
//

import UIKit

class Utilities{
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton{
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }
    
}
