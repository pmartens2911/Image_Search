//
//  PhotoCollectionViewCell.swift
//  Image Search
//
//  Created by Paul Martens on 4/1/20.
//  Copyright © 2020 PM. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    var imageView: UIImageView?
    var cellWidthConstraint: NSLayoutConstraint?
    var cellHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.imageView = imageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Cell dimension constraints code
        contentView.translatesAutoresizingMaskIntoConstraints = false
        cellWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: 200.0)
        cellHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 200.0)
    }

    func set(width: CGFloat) {
        cellWidthConstraint?.constant = width
        cellWidthConstraint?.isActive = true
    }
    
    func set(height: CGFloat) {
        cellHeightConstraint?.constant = height
        cellHeightConstraint?.isActive = true
    }
}
