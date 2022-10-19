//
//  ProfileFilterView.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/18/22.
//

import UIKit
private let reuseIdentifier = "ProfileFilterCell"

class ProfileFilterView: UIView{
    
    //MARK: - Properties
    //This collectionView we are using within this view
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(ProfileFilterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        //adding the collectionview
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor,left: leftAnchor, right: rightAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - UICollectionViewDataSource
extension ProfileFilterView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ProfileFilterView: UICollectionViewDelegateFlowLayout{
    //setting up the size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //we divided the cell by 3 because we want each cell to be a third of the view's heigh
        return CGSize(width: (frame.width / 3), height: frame.height)
    }
    //Define the spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
