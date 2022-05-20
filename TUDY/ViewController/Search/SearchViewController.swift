//
//  SearchViewController.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/05/20.
//

import UIKit


class SearchViewController: UIViewController {

    let cellId: String = "Cell"
    let list = ["이커머스", "ios개발", "취준"]

    lazy var searchbar: UISearchBar = {
       let searchbar = UISearchBar()
        searchbar.placeholder = "검색어를 입력해주세요."
        searchbar.searchTextField.layer.cornerRadius = 15
        searchbar.searchTextField.layer.masksToBounds = true
        return searchbar
    }()

    let bodyview = UIView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy var alldeleteLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 삭제"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    
    lazy var bodytitlestackView: UIStackView = {
        let stackV = UIStackView(arrangedSubviews: [titleLabel, alldeleteLabel])
        stackV.translatesAutoresizingMaskIntoConstraints = false
        stackV.axis = .horizontal
        stackV.alignment = .center
        stackV.distribution = .equalSpacing
        return stackV
    }()
    
    lazy var searchTableView: UITableView = {
        let cv = UITableView()
        cv.backgroundColor = .purple
        return cv
    }()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchTableView.delegate = self
        searchTableView.dataSource = self
        setNav()
        setUp()
    }
    
    func setUp() {
        view.addSubview(bodyview)
        bodyview.addSubview(bodytitlestackView)
        
        
        bodyview.backgroundColor = .red
        bodyview.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        bodytitlestackView.backgroundColor = .yellow
        bodytitlestackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().multipliedBy(0.92)
        }
    }

    func setNav() {
        self.navigationItem.titleView = searchbar
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
 
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchTableViewCell
        cell.
    }
    
    
}
