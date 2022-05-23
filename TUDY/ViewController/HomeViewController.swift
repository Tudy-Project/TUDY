//
//  HomeViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/05/18.
//

import UIKit
import SnapKit

enum Section {
    case main
}

class HomeViewController: UIViewController {
    
    private var postData: [Post] = []
    private var collectionView: UICollectionView!
    private var refreshControl = UIRefreshControl()

    // MARK: - 데이터 관리, cell들을 collectionView에 제공해주는 객체
    var dataSource: UICollectionViewDiffableDataSource<Section, Post>!
    
    lazy var floatingButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .systemGray
        
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 30
        return button
    }()
    
    lazy var customTopBar: CustomTopBar = {
        let view = CustomTopBar()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.configureCollectionView()
        self.configureDataSource()
        self.collectionView.addSubview(refreshControl)
        self.configureUI()
    }
    
    @objc func refresh(send: UIRefreshControl) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(customTopBar)
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        floatingButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
        customTopBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(view.snp.height).multipliedBy(0.13)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview().multipliedBy(1)
            make.trailing.leading.equalToSuperview()
        }
    }
    
    @objc private func didTapButton() {
        let alert = UIAlertController(title: "프로젝트 만들기", message: "플로팅버튼탭", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismass", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}

extension HomeViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            (Section, env) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(CGFloat(150))))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180)), subitems: [item])
            print(item)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    // MARK: - 컬렉션뷰레이아웃 추가, 컬렉션뷰 인스턴스 생성 역할
    func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        // MARK: - 셀 꾸미기
        let cellRegistration = UICollectionView.CellRegistration<PostListCell, Post> {
            (cell, indexPath, post) in
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.tintColor = .white
            cell.update(with: post)
            cell.contentView.backgroundColor = .systemGray4
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Post>(collectionView: collectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
        }
        
        // MARK: - 특정 시점에서 view 내의 데이터의 state를 나타낸다.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections([.main])
        //postData 대신 더미데이터 적용
        snapshot.appendItems(Post.dummyPostList)
        dataSource.apply(snapshot)
        
    }
    
    class CustomTopBar: UIView {
        
        lazy var searchButton : UIButton  = {
            let button = UIButton()
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
            let systemImage = UIImage(systemName: "magnifyingglass",withConfiguration: largeConfig )
            button.setImage(systemImage, for: .normal)
            button.tintColor = UIColor.black
            return button
        }()
        
        lazy var profileButton : UIButton = {
            let button = UIButton()
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
            let systemImage = UIImage(systemName: "person",withConfiguration: largeConfig )
            button.setImage(systemImage, for: .normal)
            button.tintColor = UIColor.black
            return button
        }()
        
        lazy var logoLabel: UILabel = {
            let label = UILabel()
            label.text = "TUDY"
            label.font = UIFont.boldSystemFont(ofSize: 25)
            return label
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupView()
        }
        
        func setupView() {
            addSubview(profileButton)
            profileButton.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(28)
                make.leading.equalToSuperview().offset(16)
                make.centerY.equalToSuperview()
            }
            
            addSubview(logoLabel)
            logoLabel.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
            
            addSubview(searchButton)
            searchButton.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.trailing.equalToSuperview().offset(-16)
                make.centerY.equalToSuperview()
            }
        }
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct InfoVCPreview: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            HomeViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone XS"))
                .previewDisplayName("iPhone XS")
            HomeViewController().toPreview().previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro Max")).previewDisplayName("iPhone 12 Pro Max")
        }
    }
}
#endif


#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }
    
    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        Preview(viewController: self)
    }
}
#endif

