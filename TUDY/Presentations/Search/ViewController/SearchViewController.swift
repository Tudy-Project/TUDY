//
//  SearchViewController.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/20.
//

import UIKit
import SwiftUI


class SearchViewController: UIViewController {

    // MARK: - Properties
    let ResultCellId: String = "cellId"
    let WorkCellId: String = "cellId"
    var ResultList = ["이커머스", "ios개발", "취준", "안녕하세요!!!!", "이것은 몇 글자일까?!?!?!"]
    var workList = ["백엔드", "프론트엔드", "iOS", "Android", "그래픽디자인", "UX/UI","3D/모션그래픽","브랜딩"]
    
    
    lazy var searchbar: UISearchBar = {
       let searchbar = UISearchBar()
        searchbar.backgroundColor = UIColor.DarkGray1
        searchbar.placeholder = "검색어를 입력해주세요."
        searchbar.searchTextField.backgroundColor = UIColor.DarkGray3
        searchbar.searchTextField.layer.cornerRadius = 3
        searchbar.searchTextField.layer.masksToBounds = true
        searchbar.searchTextField.textColor = .white
        searchbar.setImage(UIImage(), for: .search, state: .normal)
        searchbar.setImage(UIImage(named: "icCancel"), for: .clear, state: .normal)
        return searchbar
    }()

    let bodyview = UIView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = UIFont.caption11
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var noSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 내역이 없습니다."
        label.font = UIFont.caption11
        label.textColor = UIColor.DarkGray6
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var alldeleteLabel: UIButton = {
        let button = UIButton()
        let attributedTitle = NSMutableAttributedString(string: "전체삭제",
                              attributes: [NSAttributedString.Key.font : UIFont.caption11,
                                           NSAttributedString.Key.foregroundColor: UIColor.white,
                                           NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(deleteAllSearch(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var bodytitlestackView: UIStackView = {
        let stackV = UIStackView(arrangedSubviews: [titleLabel, alldeleteLabel])
        stackV.axis = .horizontal
        stackV.alignment = .center
        stackV.distribution = .equalSpacing
        return stackV
    }()
    
    lazy var workLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.caption11
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        let attrString = NSMutableAttributedString(string: "원하는 직무도\n함께 검색 해보세요!")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        return label
    }()
    
    lazy var resultCell: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 5, left: 16, bottom: 5, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(ResultCell.self, forCellWithReuseIdentifier: ResultCellId)
        cv.backgroundColor = UIColor.DarkGray1
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    lazy var workCell: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 6
        flowLayout.minimumLineSpacing = 6
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(WorkCell.self, forCellWithReuseIdentifier: WorkCellId)
        cv.backgroundColor = UIColor.DarkGray1
        cv.isScrollEnabled = false
        cv.allowsMultipleSelection = true
        return cv
    }()

    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureUI()
        setDelegate()
        resultCell.tag = 1
        workCell.tag = 2
    }
    
    // MARK: - Methods
    func configureUI() {
        view.backgroundColor = UIColor.DarkGray1
    func configureUI() {
        view.backgroundColor = UIColor.DarkGray1

        view.addSubview(bodyview)
        bodyview.addSubview(bodytitlestackView)
        bodyview.addSubview(resultCell)
        bodyview.addSubview(workLabel)
        bodyview.addSubview(workCell)
        
        bodyview.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        bodytitlestackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.88)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.centerX.equalToSuperview()
        }
        resultCell.snp.makeConstraints { make in
            make.top.equalTo(bodytitlestackView.snp.bottom).offset(-10)
            make.width.equalToSuperview().multipliedBy(0.94)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
        }
        
        workLabel.snp.makeConstraints { make in
            make.top.equalTo(bodytitlestackView.snp.bottom).offset(50)
            make.leading.equalTo(bodytitlestackView.snp.leading)
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        workCell.snp.makeConstraints { make in
            make.top.equalTo(workLabel.snp.bottom)
            make.leading.equalTo(workLabel.snp.leading)
            make.width.equalTo(bodytitlestackView.snp.width)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
    }

    func configurenoSearchLabel() {
        bodyview.addSubview(noSearchLabel)
        noSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(bodytitlestackView.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel.snp.leading)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureNav() {
        self.navigationItem.titleView = searchbar
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setDelegate() {
        resultCell.delegate = self
        resultCell.dataSource = self
        searchbar.delegate = self
        workCell.delegate = self
        workCell.dataSource = self
    }
    
    @objc func deleteAllSearch(_: UIButton) {
        ResultList.removeAll()
        resultCell.reloadData()
        resultCell.removeFromSuperview()
        configurenoSearchLabel()
    }
}

    // MARK: - extensions
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         var idx: Int = 0

         if (collectionView.tag == 1) {
             idx = ResultList.count
         }
         else {
             idx = workList.count
         }
         return idx
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         if collectionView.tag == 1 {
             guard let result = resultCell.dequeueReusableCell(withReuseIdentifier: ResultCellId, for: indexPath) as? ResultCell else {
                 return UICollectionViewCell()
             }
             result.configureLabel(name: ResultList[indexPath.item])
             result.contentView.layer.cornerRadius = result.contentView.frame.height / 2
             result.contentView.backgroundColor = UIColor.DarkGray5
             return result
         }
         else {
             guard let work = workCell.dequeueReusableCell(withReuseIdentifier: WorkCellId, for: indexPath) as? WorkCell else {
                 return UICollectionViewCell()
             }
             if (indexPath.row == 2) {
                 work.workTitle.textColor = .black
                 work.workCircle.backgroundColor = .black
             }
             work.contentView.layer.cornerRadius = 10
             work.workIcon.image = UIImage(named: "mac_icon")
             work.workTitle.text = workList[indexPath.row]
             work.contentView.backgroundColor = UIColor.DarkGray5
             work.contentView.backgroundColor = UIColor.WorkColorArr[indexPath.row]
             return work
         }
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         if (collectionView.tag == 1) {
             return ResultCell.fittingSize(availableHeight: 40, name: ResultList[indexPath.item])
         } else {
             let halfWidth = bodytitlestackView.bounds.width / 3
             return CGSize(width: halfWidth * 0.95 , height: halfWidth * 1.03)
         }
     }
    
}

extension SearchViewController: UISearchBarDelegate, UITextFieldDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchbar.text else {
            return
        }
        if (ResultList.isEmpty) {
            noSearchLabel.removeFromSuperview()
            configureUI()
        }
        ResultList.insert(text, at: 0)
        searchbar.text = ""
        resultCell.reloadData()
        searchbar.resignFirstResponder()
    }
}

