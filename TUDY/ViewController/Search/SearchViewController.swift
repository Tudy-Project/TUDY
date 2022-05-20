//
//  SearchViewController.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/20.
//

import UIKit

class SearchViewController: UIViewController {

    let cellId = "Cell"
    let progTheme = ["웹개발", "iOS개발", "안드로이드개발", "서버개발", "AI개발", "게임개발"]
    let designTheme = ["UI/UX디자인", "게임디자인"]
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "직무를 선택해주세요."
        label.textColor = .black
        label.font = label.font.withSize(20)
        return label
    }()
    
    lazy var computerLabel: UILabel = {
        let label = UILabel()
        label.text = "개발자"
        label.textColor = .lightGray
        label.font = label.font.withSize(15)
        return label
    }()
    
    lazy var designLabel: UILabel = {
        let label = UILabel()
        label.text = "디자이너"
        label.textColor = .lightGray
        label.font = label.font.withSize(15)
        return label
    }()
    
    lazy var themeCollectionView: UICollectionView = {
        let flowlayout = CollectionViewLeftAlignFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        cv.backgroundColor = .yellow
        cv.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        if let flowLayout = cv.collectionViewLayout as? UICollectionViewFlowLayout {
                    flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                  }
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "TUDY"
        setUp()
        themeCollectionView.delegate = self
        themeCollectionView.dataSource = self
    }
    
    func setUp() {
        view.addSubview(titleLabel)
        view.addSubview(computerLabel)
        view.addSubview(designLabel)
        view.addSubview(themeCollectionView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        themeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        computerLabel.snp.makeConstraints { make in
            make.top.equalTo(themeCollectionView.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(titleLabel)
        }
    
        designLabel.snp.makeConstraints { make in
            make.top.equalTo(computerLabel.snp.bottom).offset(100)
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(titleLabel)
        }
    }
}


extension SearchViewController: UICollectionViewDelegate {
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return progTheme.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCollectionViewCell
        cell.label.text = progTheme[indexPath.item]
        cell.backgroundColor = .white
        return cell
    }
}
