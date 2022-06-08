//
//  relatedJobCategoriesView.swift
//  TUDY
//
//  Created by jamescode on 2022/06/02.
//

import UIKit
import SnapKit

class OptionSelectionBar: UIView {
    
    // MARK: - Properties
    let title: UILabel = {
        let label = UILabel()
        label.font = .sub16
        label.textColor = .white
        return label
    }()
    
    let chevronDown: UIImageView = {
        let image = UIImageView(image: UIImage(named: "downChevron"))
        return image
    }()
    
    let optionalLabel = UILabel().label(text: "(선택)", font: .body14)
    
    init(title: String) {
        super.init(frame: .zero)
        self.commonInit()
        self.title.text = title
        if self.title.text == "관련 직무 카테고리 📌" {
            optionalLabel.text = ""
        }
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        self.backgroundColor = .DarkGray1
        self.addSubview(title)
        self.addSubview(chevronDown)
        self.addSubview(optionalLabel)
        
        constraintsUI()
    }
    
    private func constraintsUI() {
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        chevronDown.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-11)
            make.centerY.equalToSuperview()
        }
        
        optionalLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chevronDown.snp.leading).offset(-13.6)
            make.centerY.equalToSuperview()
        }
    }
}
