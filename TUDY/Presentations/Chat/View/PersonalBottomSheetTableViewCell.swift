//
//  PersonalBottomSheetTableViewCell.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/15.
//

import UIKit

class PersonalBottomSheetTableViewCell: UITableViewCell {

    // MARK: - properties
    static let reuseIdentifier = "PersonalBottomSheetTableViewCell"
    
    var isCheck: Bool = false {
        didSet {
            let imageName = isCheck ? "circle" : "checkmark.circle.fill"
            checkBoxButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        isCheck.toggle()
    }

    lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var titleStackView: UIStackView = {
        let stackview = UIStackView(arrangedSubviews: [checkBoxButton, titleLabel, participantsCountButton])
        stackview.axis = .horizontal
        stackview.spacing = 6
        return stackview
    }()
    
    let titleLabel = UILabel().label(text: "", font: .sub16, numberOfLines: 1)
    let participantsCountButton = UIButton().peopleCountButton()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PersonalBottomSheetTableViewCell {

    private func configureUI() {
        backgroundColor = .DarkGray3

        addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(200)
        }
    }
}
