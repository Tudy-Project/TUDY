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
    let cellId: String = "Cell"
    var list = ["이커머스", "ios개발", "취준", "안녕하세요!!!!", "이것은 몇 글자일까?!?!?!"]

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
        label.textColor = UIColor.DarkGray3
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
        label.text = "원하는 직무도\n함께 검색 해보세요!"
        label.font = UIFont.caption11
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var resultCell: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 5, left: 16, bottom: 5, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.register(ResultCell.self, forCellWithReuseIdentifier: cellId)
        cv.backgroundColor = UIColor.DarkGray1
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()

    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureUI()
        setDelegate()
    }
    
    // MARK: - Methods
    func configureUI() {
        view.backgroundColor = UIColor.DarkGray1
        self.searchbar.becomeFirstResponder()

        view.addSubview(bodyview)
        bodyview.addSubview(bodytitlestackView)
        bodyview.addSubview(resultCell)
        
        bodyview.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        bodytitlestackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.92)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.centerX.equalToSuperview()
        }
        resultCell.snp.makeConstraints { make in
            make.top.equalTo(bodytitlestackView.snp.bottom).offset(-10)
            make.width.equalToSuperview().multipliedBy(0.94)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()

        }
    }

    func configurenoSearchLabel() {
        bodyview.addSubview(noSearchLabel)
        noSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(bodytitlestackView.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel.snp.leading).offset(10)
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
    }
    
    @objc func deleteAllSearch(_: UIButton) {
        list.removeAll()
        resultCell.reloadData()
        resultCell.removeFromSuperview()
        configurenoSearchLabel()
    }
}

    // MARK: - extensions
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return list.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ResultCell
         cell.configureLabel(name: list[indexPath.item])
         cell.contentView.layer.cornerRadius = cell.contentView.frame.height / 2
         cell.contentView.backgroundColor = UIColor.DarkGray5
         return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return ResultCell.fittingSize(availableHeight: 40, name: list[indexPath.item])
     }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchbar.text else {
            return
        }
        if (list.isEmpty) {
            noSearchLabel.removeFromSuperview()
            configureUI()
        }
        list.append(text)
        searchbar.text = ""
        resultCell.reloadData()
    }
}

