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
    
    var postData: [Post] = []
    
    var collectionView: UICollectionView!
    // MARK: - 데이터 관리, cell들을 collectionView에 제공해주는 객체
    var dataSource: UICollectionViewDiffableDataSource<Section, Post>!

    private let floatingButton: UIButton = {
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
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        
        self.view.insertSubview(blurEffectView, at: 0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        
        self.configureCollectionView()
        self.configureDataSource()
        view.addSubview(collectionView)
        view.addSubview(customTopBar)
        view.addSubview(floatingButton)
        view.bringSubviewToFront(customTopBar)
        
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                customTopBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                customTopBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13),
                customTopBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                customTopBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
               ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 80, y: view.frame.size.height - 80, width: 60, height: 60)
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
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.7)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
        }
    }
    
    // MARK: - 컬렉션뷰레이아웃 추가, 컬렉션뷰 인스턴스 생성 역할
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView!)
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
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(systemImage, for: .normal)
            button.tintColor = UIColor.black
            return button
        }()
        
        lazy var logoLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
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
            addSubview(logoLabel)
            addSubview(searchButton)
               

               NSLayoutConstraint.activate([
                
                logoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                 logoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                logoLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                
                   //가로 크기
                   searchButton.widthAnchor.constraint(equalToConstant: 24),
                   //세로 크기
                   searchButton.heightAnchor.constraint(equalTo: searchButton.widthAnchor),
                   //서치버튼의 끝위치는 부모뷰의 끝위치와 같다
                   searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                   searchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
               ])
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

