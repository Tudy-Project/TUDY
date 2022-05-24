//
//  WorkThemeView.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/20.
//

import UIKit

class WorkThemeHeader: UICollectionReusableView {
    
    static var cellId = "cell"
    
    lazy var headerlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
}

class WorkThemeView: UIView {
    
    let ProgList = ["프론트엔드", "백엔드", "Android", "iOS"]
    let DesignList = ["UX/UI", "그래픽디자인", "브랜딩", "3D/모션그래픽"]

//    lazy var workThemeCollectionView: UICollectionView = {
//        let cv = UICollectionView()
//        cv.register(WorkThemeCollectionViewCell.self, forCellWithReuseIdentifier: WorkThemeCollectionViewCell.cellId)
//        cv.register(WorkThemeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WorkThemeHeader.cellId)
//        return cv
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
//        configureUI()
//        workThemeCollectionView.delegate = self
//        workThemeCollectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//extension WorkThemeView {
//    func configureUI() {
//        self.addSubview(workThemeCollectionView)
//        
//        workThemeCollectionView.snp.makeConstraints { make in
//            make.top.bottom.leading.trailing.equalToSuperview()
//        }
//    }
//}

//extension WorkThemeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return ProgList.count
//        }
//        else {
//            return DesignList.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkThemeCollectionViewCell.cellId, for: indexPath) as! WorkThemeCollectionViewCell
//        if indexPath.section == 0 {
//            cell.workThemeButton.titleLabel?.text = ProgList[indexPath.row]
//        }
//        else if indexPath.section == 1 {
//            cell.workThemeButton.titleLabel?.text = DesignList[indexPath.row]
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WorkThemeHeader.cellId, for: indexPath) as! WorkThemeHeader
//        if indexPath.section == 0 {
//            header.headerlabel.text = "개발"
//        }
//        else {
//            header.headerlabel.text = "디자인"
//        }
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: self.frame.size.width, height: 200)
//    }
//}


//class SearchViewController: UIViewController {
//
//    let cellId = "Cell"
//    let progTheme = ["웹개발", "iOS개발", "안드로이드개발", "서버개발", "AI개발", "게임개발"]
//    let designTheme = ["UI/UX디자인", "게임디자인"]
//    
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "직무를 선택해주세요."
//        label.textColor = .black
//        label.font = label.font.withSize(20)
//        return label
//    }()
//    
//    lazy var computerLabel: UILabel = {
//        let label = UILabel()
//        label.text = "개발자"
//        label.textColor = .lightGray
//        label.font = label.font.withSize(15)
//        return label
//    }()
//    
//    lazy var designLabel: UILabel = {
//        let label = UILabel()
//        label.text = "디자이너"
//        label.textColor = .lightGray
//        label.font = label.font.withSize(15)
//        return label
//    }()
//    
//    lazy var themeCollectionView: UICollectionView = {
//        let flowlayout = CollectionViewLeftAlignFlowLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
//        cv.backgroundColor = .yellow
//        cv.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//        if let flowLayout = cv.collectionViewLayout as? UICollectionViewFlowLayout {
//                    flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//                  }
//        return cv
//    }()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        self.navigationItem.title = "TUDY"
//        setUp()
//        themeCollectionView.delegate = self
//        themeCollectionView.dataSource = self
//    }
//    
//    func setUp() {
//        view.addSubview(titleLabel)
//        view.addSubview(computerLabel)
//        view.addSubview(designLabel)
//        view.addSubview(themeCollectionView)
//        
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(100)
//            make.leading.equalToSuperview().offset(20)
//            make.width.equalToSuperview().multipliedBy(0.5)
//            make.height.equalToSuperview().multipliedBy(0.05)
//        }
//        
//        themeCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(10)
//            make.centerX.equalToSuperview()
//            make.width.equalToSuperview().multipliedBy(0.9)
//            make.height.equalToSuperview().multipliedBy(0.5)
//        }
//        
//        computerLabel.snp.makeConstraints { make in
//            make.top.equalTo(themeCollectionView.snp.bottom)
//            make.leading.equalToSuperview().offset(20)
//            make.width.equalToSuperview().multipliedBy(0.5)
//            make.height.equalTo(titleLabel)
//        }
//    
//        designLabel.snp.makeConstraints { make in
//            make.top.equalTo(computerLabel.snp.bottom).offset(100)
//            make.leading.equalToSuperview().offset(20)
//            make.width.equalToSuperview().multipliedBy(0.5)
//            make.height.equalTo(titleLabel)
//        }
//    }
//}
//
//
//extension SearchViewController: UICollectionViewDelegate {
//    
//}
//
//extension SearchViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return progTheme.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCollectionViewCell
//        cell.label.text = progTheme[indexPath.item]
//        cell.backgroundColor = .white
//        return cell
//    }
//}
