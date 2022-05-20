//
//  HomeViewController.swift
//  TUDY
//
//  Created by jamescode on 2022/05/18.
//

import UIKit
import SnapKit


class HomeViewController: UIViewController {
    
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
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.idendifier)
        return table
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(customTopBar)
        view.addSubview(homeFeedTable)
        view.bringSubviewToFront(customTopBar)
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
                
                customTopBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                customTopBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13),
                customTopBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                customTopBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                
                homeFeedTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                homeFeedTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                homeFeedTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                homeFeedTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
               ])
        
       
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.tableHeaderView = UIView(frame: CGRect(x:0, y:0, width: view.bounds.width, height: 150))
        homeFeedTable.backgroundColor = .yellow
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.frame
        floatingButton.frame = CGRect(x: view.frame.size.width - 80, y: view.frame.size.height - 80, width: 60, height: 60)
    }
    
    @objc private func didTapButton() {
        let alert = UIAlertController(title: "프로젝트 만들기", message: "플로팅버튼탭", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismass", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
}

extension HomeViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 20
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.idendifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
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

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct InfoVCPreview: PreviewProvider {
    
    static var previews: some View {
        // view controller using programmatic UI
        Group {
            HomeViewController().toPreview()
            HomeViewController().toPreview()
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
