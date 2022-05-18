//
//  CollectionViewTableViewCell.swift
//  TUDY
//
//  Created by jamescode on 2022/05/19.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    static let idendifier = "collectionViewTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
     
}
