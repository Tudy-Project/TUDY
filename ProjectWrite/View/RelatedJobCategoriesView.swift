//
//  relatedJobCategoriesView.swift
//  TUDY
//
//  Created by jamescode on 2022/06/02.
//

import UIKit
import SnapKit

class RelatedJobCategoriesView: UIView {
    
    let title: UILabel = {
        let label = UILabel()
//        label.text = "관련 직무 카테고리 📌"
        label.font = .sub16
        label.textColor = .white
        return label
    }()
    
    let chevronDown: UIImageView = {
        let image = UIImageView(image: UIImage(named: "downChevron"))
        return image
    }()
        
    init(title: String) {
        super.init(frame: .zero)
        self.commonInit()
        self.title.text = title
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = .DarkGray1
        self.addSubview(title)
        self.addSubview(chevronDown)
        
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
    }
}
