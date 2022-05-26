//
//  setInterestedJobViewController.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

class SetInterestedJobViewController: UIViewController {
    
    // MARK: - Properties
    private let logoLabel = UILabel().label(text: "TUDY", font: .title)
    private let guideLabel = UILabel().label(text: "관심 직무를 선택해주세요.", font: .sub20)
    private let detailGuideLabel = UILabel().label(text: "관심 직무는 언제든지 마이 페이지에서 수정이 가능해요.", font: .caption11)
    // 직무선택 collectionView
    private let nextButton = UIButton().nextButton()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension SetInterestedJobViewController {
    
    // MARK: - Methods
    private func configureUI() {
        view.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(94)
            make.leading.equalTo(view.snp.leading).offset(26)
        }
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(64)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        view.addSubview(detailGuideLabel)
        detailGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(6)
            make.leading.equalTo(view.snp.leading).offset(32)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(50)
        }
    }
}
