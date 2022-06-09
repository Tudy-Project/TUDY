//
//  SearchResultCollectionViewCell.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/08.
//

import UIKit

class ResultCell: UICollectionViewCell {

    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.DarkGray5
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - Lift Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
}

    // MARK: - Methods
extension ResultCell {
    static func fittingSize(availableHeight: CGFloat, name: String?) -> CGSize {
        let cell = ResultCell()
        cell.configureLabel(name: name)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width + 10, height: availableHeight)
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    private func configureUI() {
        backgroundColor = UIColor.DarkGray1
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(15)
        }
    }
    
    func configureLabel(name: String?) {
        titleLabel.text = name
    }
}
