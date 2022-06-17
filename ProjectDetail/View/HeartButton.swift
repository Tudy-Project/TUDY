//
//  HeartButton.swift
//  TUDY
//
//  Created by jamescode on 2022/06/17.
//

import UIKit
import Alamofire

class HeartButton: UIButton {
    
    // MARK: - Properties
    var isActivated : Bool = false
    let activatedImage = UIImage(named: "love_fill")
    let normalImage = UIImage(named: "love")
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setState(_ newValue: Bool) {
        //현재 버튼 상태 변경
        isActivated = newValue
        //변경된 상태에 따른 이미지 변경

        self.setImage(self.isActivated ? activatedImage : normalImage, for: .normal)
    }
    
    fileprivate func configureAction() {
        self.addTarget(self, action: #selector(onBtnClicked(_:)), for: .touchUpInside)
    }
    
    @objc fileprivate func onBtnClicked(_ sender: UIButton) {
        self.isActivated.toggle()
        //animation 처리
        animate()
    }
    
    fileprivate func animate() {

        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            
            let newImage = self.isActivated ? self.activatedImage : self.normalImage
            // onclick heart button scale down 50% -> duration 0.1sec
            self.transform = self.transform.scaledBy(x: 0.5, y: 0.5)
            self.setImage(newImage, for: .normal)
        }, completion: { _ in
            // reset origin size 0.1sec
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
