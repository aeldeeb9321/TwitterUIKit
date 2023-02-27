//
//  CaptionTextView.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/13/22.
//

import UIKit

class CaptionTextView: UITextView {
    
    //MARK: - Properties
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "What's happening?"
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true
        addSubview(placeHolderLabel)
        //This class is already a subclass of UIView so we dont need to access the view component compared to our controllers
        placeHolderLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleTextInputChange() {
        //This makes it so our placeholder disappears when we start typing, and comes back when we deleted what we typed. You can type this with conditions but this is cleaner
        placeHolderLabel.isHidden = !text.isEmpty
    }
}
