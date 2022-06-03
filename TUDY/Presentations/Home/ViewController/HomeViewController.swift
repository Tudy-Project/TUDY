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
    
    // MARK: - Property
    enum Event {
        case showSearch
        case showProjectWrite
        case showLogin
    }
    var didSendEventClosure: ((Event) -> Void)?
    
    private var postData: [Post] = []
    
    //    private var refreshControl = UIRefreshControl()
    private var collectionView: UICollectionView! = nil
    
    private let sectionHeaderElementKind = "section-header-element-kind"
    
    //데이터 관리, cell들을 collectionView에 제공해주는 객체
    private var dataSource: UICollectionViewDiffableDataSource<Section, Post>!
    
    lazy var jobOfInterestBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var jobOfInterestButton: UIButton = {
        let button = UIButton().imageButton(imageName: "arrowtriangle.down.fill")
        button.setTitle("관심 직무", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.semanticContentAttribute = .forceRightToLeft
        button.addTarget(self, action: #selector(didTapJobButton), for: .touchUpInside)
        return button
    }()
    
    lazy var floatingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 30
        return button
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        configureUI()
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "TUDY"
//        navigationController?.navigationBar.topItem?.title = "TUDY"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "AppleSDGothicNeoEB00", size: 26)!
        ]
        
        navigationController?.navigationBar.tintColor = .white
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func configureUI() {
        let leftItem = UIBarButtonItem(image:UIImage(named: "profile"), style: .plain, target: self, action: #selector(searchButtonPressed))
        self.navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(image:UIImage(named: "magnify"), style: .plain, target: self, action: #selector(searchButtonPressed))
        self.navigationItem.rightBarButtonItem = rightItem
    
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        
        floatingButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
        
        view.addSubview(jobOfInterestBar)
        jobOfInterestBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(55)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        jobOfInterestBar.addSubview(jobOfInterestButton)
        jobOfInterestButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(jobOfInterestBar.snp.bottom)
            make.bottom.equalToSuperview().multipliedBy(1)
            make.trailing.leading.equalToSuperview()
        }
    }
}

// MARK: - action method
extension HomeViewController {
    @objc private func refresh(send: UIRefreshControl) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc private func didTapJobButton() {
        let alert = UIAlertController(title: "관심 직무 선택", message: "관심직무탭", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismass", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapFloatingButton() {
        if isLogin() {
            didSendEventClosure?(.showProjectWrite)
        } else {
            didSendEventClosure?(.showLogin)
        }
    }
    
    @objc private func searchButtonPressed(_: UIButton) {
        didSendEventClosure?(.showSearch)
//        let searchVC = SearchViewController()
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}
extension HomeViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout {
            (Section, env) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(CGFloat(150))))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            //headerView 설정
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: self.sectionHeaderElementKind, alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
    }
    
    // 컬렉션뷰레이아웃 추가, 컬렉션뷰 인스턴스 생성 역할
    func configureCollectionView() {
       
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        //        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    func configureDataSource() {
        // cell custom
        let cellRegistration = UICollectionView.CellRegistration<PostListCell, Post> {
            (cell, indexPath, post) in
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = false
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 5.0
            cell.tintColor = .black
            cell.update(with: post)
            cell.contentView.backgroundColor = .white
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Post>(collectionView: collectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        
        //collectionview headerView custom
        let headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: self.sectionHeaderElementKind) {supplementaryView,elementKind,indexPath in
            supplementaryView.backgroundColor = .white
        }
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
        
        // 특정 시점에서 view 내의 데이터의 state를 나타낸다.
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections([.main])
        //postData 대신 더미데이터 적용
        snapshot.appendItems(Post.dummyPostList)
        dataSource.apply(snapshot)
        
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
           self.navigationController?.pushViewController(ProjectDetailViewController(), animated: true)
           let indexPath = indexPath.row
           print("home collectionItem indexpath \(indexPath)")
    }
}

// MARK: - Login Check Protocol
extension HomeViewController: LoginCheck {}

extension UIApplication {

    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
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

