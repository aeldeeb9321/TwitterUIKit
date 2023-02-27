//
//  ProfileFilterView.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/18/22.
//

import UIKit
private let reuseIdentifier = "ProfileFilterCell"

protocol ProfileFilterViewDelegate: AnyObject {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath)
}
class ProfileFilterView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: ProfileFilterViewDelegate?
    
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
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        //Selects the item at the specified index path and optionally scrolls it into view,i.e. makes the first cell selected ("Tweets")
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        //adding the collectionview
        addSubview(collectionView)
        //Making the collection view fill the view
        collectionView.anchor(top: topAnchor,left: leftAnchor,bottom: bottomAnchor, right: rightAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDataSource

extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileFilterCell
        //construct the filter
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = option //this will fire up the didSet in ProfileFilterCell in order to set the titleLabel of the cell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count //we can now scale our datamodel 
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout (gets called everytime you select an item)

extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    //setting up the size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellCount = CGFloat(ProfileFilterOptions.allCases.count)
        //we divided the cell by 3 because we want each cell to be a third of the view's heigh
        return CGSize(width: (frame.width / cellCount), height: frame.height)
    }
    //Define the spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filterView(self, didSelect: indexPath)
    }
}


