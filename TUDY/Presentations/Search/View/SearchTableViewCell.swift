//
//  SearchTableViewCell.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/20.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    lazy var currentsearchText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("x", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()

    // MARK: - Lift Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - extensions
extension SearchTableViewCell {
    private func configureUI() {
        self.addSubview(currentsearchText)
        self.contentView.addSubview(cancelButton)
        
        currentsearchText.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }
}
