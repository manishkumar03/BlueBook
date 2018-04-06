//
//  BookCell.swift
//  BlueBook
//
//  Created by Manish Kumar on 2018-02-09.
//  Copyright © 2018 Manish Kumar. All rights reserved.
//

import UIKit

class BookCell: UICollectionViewCell {
    var whiteRoundedView: UIView!
    var cellImageView: UIImageView!
    let padding: CGFloat = 8.0
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpCell()
    }
    
    func setUpCell() {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 3*padding)/2
        self.backgroundColor = UIColor.clear
        
        /*********************************************************************************/
        // MARK: whiteRoundedView implementation
        /*********************************************************************************/
        let whiteRoundedView = UIView()
        self.addSubview(whiteRoundedView)
        whiteRoundedView.translatesAutoresizingMaskIntoConstraints = false
        
        let leading01 = NSLayoutConstraint(item: whiteRoundedView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: padding)
        
        let top01 = NSLayoutConstraint(item: whiteRoundedView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: padding)
        
        let trailing01 = NSLayoutConstraint(item: whiteRoundedView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -1*padding)
        
        let bottom01 = NSLayoutConstraint(item: whiteRoundedView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -1*padding)
        
        self.addConstraints([leading01, top01, trailing01, bottom01])
        
        whiteRoundedView.layer.backgroundColor = UIColor(red: 0.3569, green: 0.7373, blue: 0, alpha: 0.5).cgColor
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 4.0
//        whiteRoundedView.layer.shadowOffset = CGSize(width:-4, height:4)
//        whiteRoundedView.layer.shadowOpacity = 0.3
        contentView.sendSubview(toBack: whiteRoundedView)
        
        /*********************************************************************************/
        // MARK: cellImageView implementation
        /*********************************************************************************/
        
        /** channelCellImageView will be positioned at top left of the whiteRoundedView. */
        
        cellImageView = UIImageView()
        self.addSubview(cellImageView)
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.image = UIImage()
        cellImageView.contentMode = .scaleAspectFit
        
        let leading02 = NSLayoutConstraint(item: cellImageView, attribute: .leading, relatedBy: .equal, toItem: whiteRoundedView, attribute: .leading, multiplier: 1, constant: padding)
        
        let top02 = NSLayoutConstraint(item: cellImageView, attribute: .top, relatedBy: .equal, toItem: whiteRoundedView, attribute: .top, multiplier: 1, constant: padding)
        
        let trailing02 = NSLayoutConstraint(item: cellImageView, attribute: .trailing, relatedBy: .equal, toItem: whiteRoundedView, attribute: .trailing, multiplier: 1, constant: -1*padding)
        
        let bottom02 = NSLayoutConstraint(item: cellImageView, attribute: .bottom, relatedBy: .equal, toItem: whiteRoundedView, attribute: .bottom, multiplier: 1, constant: -1*padding)
        
        self.addConstraints([leading02, top02, trailing02, bottom02])
        
        cellImageView.layer.masksToBounds = false
        cellImageView.layer.cornerRadius = 6.0
        cellImageView.layer.shadowOffset = CGSize(width:-4, height:4)
        cellImageView.layer.shadowOpacity = 0.3
        
    }
    
}
