//
//  CategoriesViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/06/08.
//

import UIKit
import SnapKit

class CategoriesViewController: UIViewController {
    
    // MARK: - Properties
    private let initButton: UILabel = {
        let label = UILabel().label(text: "초기화", font: .sub14)
            label.underline()
        return label
    }()
    
    private let developLabel = UILabel().label(text: "개발", font: .sub14)
    private let designLabel = UILabel().label(text: "디자인", font: .sub14)
    private var developFields: [String] = ["프론트엔드", "백엔드", "안드로이드", "iOS"]
    private var designerFields: [String] = ["UI/UX", "그래픽디자인", "브랜딩", "3D/모션그래픽"]
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    private var developCollectionView: UICollectionView!
    private var designCollectionView: UICollectionView!
    
    private var  developFieldsDataSource: DataSource!
    private var designDataSource: DataSource!
    private var selectedDevelopFields: [String] = []
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
    }
}

extension CategoriesViewController {
    // MARK: - Methods
    private func configureUI() {
        view.addSubview(initButton)
        let tapInit = UITapGestureRecognizer(target: self, action: #selector(tapInitButton))
        initButton.isUserInteractionEnabled = true
        initButton.addGestureRecognizer(tapInit)
        initButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        view.addSubview(developLabel)
        developLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(26)
            make.leading.equalToSuperview().offset(22)
        }
        view.addSubview(developCollectionView)
        developCollectionView.register(DevelopCell.self, forCellWithReuseIdentifier: DevelopCell.reuseIdentifier)
        developCollectionView.snp.makeConstraints { make in
            make.top.equalTo(developLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).offset(33)
            make.trailing.equalTo(view.snp.trailing).offset(-33)
            make.height.equalTo(100)
        }
        
        view.addSubview(designLabel)
        designLabel.snp.makeConstraints { make in
            make.top.equalTo(developCollectionView.snp.bottom).offset(23)
            make.leading.equalToSuperview().offset(22)
        }
        
        
    }
    
    // MARK: - CollectionView
    func collectionViewLayout(height: CGFloat) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureCollectionView() {
        developCollectionView = UICollectionView(frame: view.bounds,
                                                   collectionViewLayout: collectionViewLayout(height: 37))
        developCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        developCollectionView.backgroundColor = .DarkGray2
        developCollectionView.isScrollEnabled = false
        
        configureDataSource()
    }
    
    func configureDataSource() {
        let developCellRegistration =
        UICollectionView.CellRegistration<DevelopCell, String> {
            [weak self] cell, indexPath, identifier in
            cell.button.setTitle(identifier, for: .normal)
            cell.button.addTarget(self, action: #selector(self?.developButtonTapped(_:)), for: .touchUpInside)
            cell.contentView.backgroundColor = .DarkGray2
            
            if let selectedDevelopFields = self?.selectedDevelopFields {
                if selectedDevelopFields.contains(identifier) {
                    cell.button.backgroundColor = .DarkGray5
                } else {
                    cell.button.backgroundColor = .DarkGray2
                }
            }
        }
        
        developFieldsDataSource = DataSource(collectionView: developCollectionView) {
            collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: developCellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        var developFieldsSnapshot = Snapshot()
        developFieldsSnapshot.appendSections([0])
        developFieldsSnapshot.appendItems([])
        developFieldsDataSource.apply(developFieldsSnapshot)
    }
    
    private func updateDevelopFieldsSnapshotWhenTappedDevelopFields() {
        var snapshot = developFieldsDataSource.snapshot()
        snapshot.reloadItems(developFields)
        developFieldsDataSource.apply(snapshot)
    }
    
    // MARK: - Action Methods
    @objc
       func tapInitButton(sender:UITapGestureRecognizer) {
           print("tap working")
       }
    
    @objc private func developButtonTapped(_ sender: DevelopButton) {
        print("tapDevelopFieldsButton!!!")
    }
    
    @objc private func developFieldsButtonTapped(_ sender: DevelopButton) {
        guard let developFieldsName = sender.titleLabel?.text else { return }
        if selectedDevelopFields.contains(developFieldsName) {
            guard let index = selectedDevelopFields.firstIndex(of: developFieldsName) else { return }
            selectedDevelopFields.remove(at: index)
        } else {
            selectedDevelopFields.append(developFieldsName)
        }
        updateDevelopFieldsSnapshotWhenTappedDevelopFields()
    }
    
}
