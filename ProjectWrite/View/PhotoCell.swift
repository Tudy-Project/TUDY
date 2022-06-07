//
//  PhotoCell.swift
//  TUDY
//
//  Created by jamescode on 2022/06/03.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "photoCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
       return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}
