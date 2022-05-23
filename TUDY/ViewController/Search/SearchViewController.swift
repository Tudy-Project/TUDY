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
    var list = ["이커머스", "ios개발", "취준"]

    lazy var searchbar: UISearchBar = {
       let searchbar = UISearchBar()
        searchbar.placeholder = "검색어를 입력해주세요."
        searchbar.searchTextField.layer.cornerRadius = 15
        searchbar.searchTextField.layer.masksToBounds = true
        searchbar.setImage(UIImage(named: "icCancel"), for: .clear, state: .normal)
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
    
    lazy var alldeleteLabel: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
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
    
    lazy var searchTableView: UITableView = {
        let cv = UITableView()
        cv.register(SearchTableViewCell.self, forCellReuseIdentifier: cellId)
        return cv
    }()

    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchbar.delegate = self
        setNav()
        setUp()
        self.searchbar.becomeFirstResponder()
    }
    
    // MARK: - Methods
    func setUp() {
        view.addSubview(bodyview)
        bodyview.addSubview(bodytitlestackView)
        bodyview.addSubview(searchTableView)
        
        bodyview.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        bodytitlestackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.08)
            make.width.equalToSuperview().multipliedBy(0.92)
        }
        
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(bodytitlestackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func setNav() {
        self.navigationItem.titleView = searchbar
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    @objc func deleteSearch(_ sender:UIButton) {
        let indexRow = sender.tag
        list.remove(at: indexRow)
        searchTableView.deleteRows(at: [IndexPath(row: indexRow, section: 0)], with: .left)
        searchTableView.reloadData()
        if (list == []) {
            bodyview.removeFromSuperview()
        }
    }
    
    @objc func deleteAllSearch(_: UIButton) {
        list.removeAll()
        searchTableView.reloadData()
        bodyview.removeFromSuperview()
    }
}

    // MARK: - extensions
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchTableViewCell
        cell.currentsearchText.text = list[indexPath.row]
        cell.cancelButton.tag = indexPath.row
        cell.cancelButton.addTarget(self, action: #selector(deleteSearch(_:)), for: .touchUpInside)
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchbar.text else {
            return
        }
        list.append(text)
        searchTableView.reloadData()
    }
}
