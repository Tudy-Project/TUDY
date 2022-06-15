//
//  ProjectDetailViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/05/30.
//

import UIKit

class ProjectDetailViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var detailTitle: UILabel = {
        let label = UILabel().label(text: testData().title[0] , font: UIFont.sub20, color: .white)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var detailDesc: UILabel = {
        let label = UILabel().label(text:testData().contents[0], font: UIFont.body14, color: .white)
        return label
    }()
    
    private lazy var authorName: UILabel = {
        let label = UILabel().label(text: testData().contents[0], font: UIFont.caption11, color: .white)
        return label
    }()
    
    lazy var authorImage: UIImageView = {
        let ImageView = UIImageView()
        ImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        ImageView.loadFrom(URLAddress: postData!.imageUrl)
        ImageView.contentMode = .scaleAspectFit
        ImageView.layer.cornerRadius = ImageView.frame.width / 2
        ImageView.clipsToBounds = true
        return ImageView
    }()
    
    lazy var postImage: UIImageView = {
        let ImageView = UIImageView()
        return ImageView
    }()
    
    private let heartButton = UIButton().imageButton(imageName: "heart")
    
    private let heartCount = UILabel().label(text: "12", font: UIFont.sub14, color: .white)
    
    private let uploadDate = UILabel().label(text: "2022/4/12  14:02", font: UIFont.caption12, color: .white)
    
    private let projectConditionsLabel = UILabel().label(text: "프로젝트 조건 💡", font: UIFont.sub20, color: .white)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavSettings()
        configureUI()
        tabDisappear()
    }
    
    private func configureNavSettings() {
        view.backgroundColor = .DarkGray1
        navigationController?.navigationBar.backgroundColor = .DarkGray2
        title = ""
        //네비게이션바 왼쪽 타이틀
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        
        let more = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [more]
    }
    private func configureUI() {
        view.addSubview(detailTitle)
        view.addSubview(authorName)
        view.addSubview(detailDesc)
        view.addSubview(postImage)
        view.addSubview(authorImage)
        view.addSubview(uploadDate)
        view.addSubview(projectConditionsLabel)
        
        detailTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            make.leading.equalToSuperview().offset(30)
        }
        
        detailDesc.snp.makeConstraints { make in
            make.top.equalTo(detailTitle.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(30)
        }
    }
}
