//
//  TweetHeader.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 1/28/23.
//

import UIKit

class TweetHeader: UICollectionReusableView {
    //MARK: - Properties
    
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureReusableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureReusableView() {
        
    }
}
