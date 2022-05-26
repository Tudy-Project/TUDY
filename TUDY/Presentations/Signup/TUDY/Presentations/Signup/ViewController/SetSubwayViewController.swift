//
//  setSubwayViewControoler.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

class SetSubwayViewController: UIViewController {
    
    // MARK: - Properties
    private let logoLabel = UILabel().label(text: "TUDY", font: .title)
    private let guideLabel = UILabel().label(text: "출발 지하철역을 입력해주세요.", font: .sub20)
    
    private let detailGuideLabel: UILabel = {
        let label = UILabel().label(text: "팀원간 중간지점을 잡을 때 활용해요 !\n남에게 보이지 않고 언제든지 수정 가능해요.", font: .caption11)
        label.numberOfLines = 0
        return label
    }()
    
    private let subwayTextField = UITextField().textField(withPlaceholder: "지하철 명을 입력해주세요.")
    private let signUpButton = UIButton().nextButton(text: "가입하기")
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension SetSubwayViewController {
    
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
        
        view.addSubview(subwayTextField)
        subwayTextField.snp.makeConstraints { make in
            make.top.equalTo(detailGuideLabel.snp.top).offset(38)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(20)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
            make.height.equalTo(50)
        }
    }
}
