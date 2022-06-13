//
//  ProjectDetailViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/05/30.
//

import UIKit

class ProjectDetailViewController: UIViewController {
    
    // MARK: - Properties
//    private lazy var detailTitle: UILabel = {
//        let label = UILabel().label(text: postData?.title ?? "제목 없음", font: UIFont.sub20, color: .white)
//        label.numberOfLines = 2
//        return label
//    }()
    
//    private lazy var detailDesc: UILabel = {
//        let label = UILabel().label(text: postData?.desc ?? "내용 없음", font: UIFont.body14, color: .white)
//        return label
//    }()
    
//    private lazy var authorName: UILabel = {
//        let label = UILabel().label(text: postData?.writer ?? "작성자 없음", font: UIFont.caption11, color: .white)
//        return label
//    }()
    
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
    
    private let projectConditions = UILabel().label(text: "프로젝트 조건 💡", font: UIFont.sub20, color: .white)
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavSettings()
        configureUI()
    }
    
    private func configureNavSettings() {
        view.backgroundColor = .DarkGray1
        navigationController?.navigationBar.backgroundColor = .DarkGray2
        title = ""
        //네비게이션바 왼쪽 타이틀
        navigationController?.navigationBar.topItem?.title = "홈"
        tabBarController?.tabBar.isHidden = true
        
        let heart = UIBarButtonItem(image: UIImage(systemName: "heart"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
        let more = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: UIBarButtonItem.Style.plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [more, heart]
    }
    private func configureUI() {
        
    }
}
