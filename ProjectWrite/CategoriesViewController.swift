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
    private var developFields: [String] = Jobs.allProgrammersJobs.map { $0.rawValue }
    private var designerFields: [String] = Jobs.allDesignerJobs.map { $0.rawValue }
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    private var developCollectionView: UICollectionView!
    private var designCollectionView: UICollectionView!
    
    private var  developDataSource: DataSource!
    private var designDataSource: DataSource!
    
    private var selectedDevelop: [String] = []
    private var selectedDesign: [String] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name("selectedDevelop"),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name("selectedDesign"),
                                                  object: nil)
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
        developCollectionView.snp.makeConstraints { make in
            make.top.equalTo(developLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).offset(33)
            make.trailing.equalTo(view.snp.trailing).offset(-33)
            make.height.equalTo(70)
        }
        
        view.addSubview(designLabel)
        designLabel.snp.makeConstraints { make in
            make.top.equalTo(developCollectionView.snp.bottom).offset(23)
            make.leading.equalToSuperview().offset(22)
        }
        
        view.addSubview(designCollectionView)
        designCollectionView.snp.makeConstraints { make in
            make.top.equalTo(designLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).offset(33)
            make.trailing.equalTo(view.snp.trailing).offset(-33)
            make.height.equalTo(70)
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
        
        designCollectionView = UICollectionView(frame: view.bounds,
                                                   collectionViewLayout: collectionViewLayout(height: 37))
        designCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        designCollectionView.backgroundColor = .DarkGray2
        designCollectionView.isScrollEnabled = false
        
        configureDataSource()
    }
    
    func configureDataSource() {
        let developCellRegistration =
        UICollectionView.CellRegistration<DevelopCell, String> {
            [weak self] cell, indexPath, identifier in
            cell.button.setTitle(identifier, for: .normal)
            cell.button.addTarget(self, action: #selector(self?.developButtonTapped(_:)), for: .touchUpInside)
            cell.contentView.backgroundColor = .DarkGray2
            
            if let selectedDevelop = self?.selectedDevelop {
                if selectedDevelop.contains(identifier) {
                    cell.button.backgroundColor = .DarkGray5
                } else {
                    cell.button.backgroundColor = .DarkGray2
                }
            }
        }
        
        developDataSource = DataSource(collectionView: developCollectionView) {
            collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: developCellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        var developFieldsSnapshot = Snapshot()
        developFieldsSnapshot.appendSections([0])
        developFieldsSnapshot.appendItems(developFields)
        developDataSource.apply(developFieldsSnapshot)
        
        let designCellRegistration =
        UICollectionView.CellRegistration<DevelopCell, String> {
            [weak self] cell, indexPath, identifier in
            cell.button.setTitle(identifier, for: .normal)
            cell.button.addTarget(self, action: #selector(self?.designButtonTapped(_:)), for: .touchUpInside)
            cell.contentView.backgroundColor = .DarkGray2
            
            if let selectedDesign = self?.selectedDesign {
                if selectedDesign.contains(identifier) {
                    cell.button.backgroundColor = .DarkGray5
                } else {
                    cell.button.backgroundColor = .DarkGray2
                }
            }
        }
        
        designDataSource = DataSource(collectionView: designCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: designCellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        })
        
        var designSnapshot = Snapshot()
        designSnapshot.appendSections([0])
        designSnapshot.appendItems(designerFields)
        designDataSource.apply(designSnapshot)
    }
    
    private func updateDevelopFieldsSnapshotWhenTappedDevelopFields() {
        var snapshot = developDataSource.snapshot()
        snapshot.reloadItems(developFields)
        developDataSource.apply(snapshot)
    }
    
    private func updateDesignFieldsSnapshotWhenTappedDesignFields() {
        var snapshot = designDataSource.snapshot()
        snapshot.reloadItems(designerFields)
        designDataSource.apply(snapshot)
    }
    
    // MARK: - Action Methods
    @objc
       func tapInitButton(sender:UITapGestureRecognizer) {
           selectedDevelop = []
           selectedDesign = []
           updateDevelopFieldsSnapshotWhenTappedDevelopFields()
           updateDesignFieldsSnapshotWhenTappedDesignFields()
           NotificationCenter.default.post(name: Notification.Name("selectedDevelop"),
                                           object: selectedDevelop)
           NotificationCenter.default.post(name: Notification.Name("selectedDesign"),
                                           object: selectedDesign)
       }
    
    @objc private func developButtonTapped(_ sender: DevelopButton) {
        guard let developName = sender.titleLabel?.text else { return }
        if selectedDevelop.contains(developName) {
            guard let index = selectedDevelop.firstIndex(of: developName) else { return }
            selectedDevelop.remove(at: index)
        } else {
            selectedDevelop.append(developName)
        }
        updateDevelopFieldsSnapshotWhenTappedDevelopFields()
        
        NotificationCenter.default.post(name: Notification.Name("selectedDevelop"),
                                        object: selectedDevelop)
    }
    
    @objc private func designButtonTapped(_ sender: DevelopButton) {
        guard let designName = sender.titleLabel?.text else { return }
        if selectedDesign.contains(designName) {
            guard let index = selectedDesign.firstIndex(of: designName) else { return }
            selectedDesign.remove(at: index)
        } else {
            selectedDesign.append(designName)
        }
        updateDesignFieldsSnapshotWhenTappedDesignFields()
        
        NotificationCenter.default.post(name: Notification.Name("selectedDesign"),
                                        object: selectedDesign)
    }
}
