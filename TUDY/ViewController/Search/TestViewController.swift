//
//  TestViewController.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/20.
//

import UIKit


// MARK: - 나중에 삭제할 VC입니다.
class TestViewController: UIViewController {

    lazy var workthemeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.setTitle("직무선택", for: .normal)
        return button
    }()

    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.setTitleColor(.black, for: .normal)
        button.setTitle("검색창", for: .normal)
        return button
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUP()
    }
    
    func setUP() {
        view.addSubview(workthemeButton)
        view.addSubview(searchButton)
        
        searchButton.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
        
        workthemeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(50)
        }
    }
    
    
//    @objc workthemeButtonPressed(_: UIButton) {
//        let communityDetailVC = DestinationDetailViewController()
//        self.navigationController!.pushViewController(communityDetailVC, animated: true)
//        print("Clicked \(indexPath.row)")
//    }
    @objc func searchButtonPressed(_: UIButton) {
        let searchVC = SearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
        print("searchButtonPressed")
    }
}
