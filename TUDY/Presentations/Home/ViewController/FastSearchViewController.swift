//
//  FastSearchViewController.swift
//  TUDY
//
//  Created by neuli on 2022/07/01.
//

import UIKit

class FastSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    enum Event {
        case showProjectDetail(project: Project)
    }
    
    var didSendEventClosure: ((Event) -> Void)?
    
    var work: String = "" {
        didSet {
            fetchProjects()
        }
    }
    
    private let bottomSheetFilterLabel = UILabel().label(text: "모집중인 스터디만 보기", font: .body14, numberOfLines: 1)
    private lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.thumbTintColor = .LightGray4
        let onColor = UIColor.PointBlue
        let offColor = UIColor.DarkGray5
        switchButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchButton.onTintColor = onColor
        switchButton.tintColor = offColor
        switchButton.layer.cornerRadius = 15
        switchButton.backgroundColor = offColor
        switchButton.clipsToBounds = true
        switchButton.addTarget(self, action: #selector(clickedSwitchButton(_:)), for: .valueChanged)
        return switchButton
    }()
    private let FilterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    typealias ProjectDataSource = UICollectionViewDiffableDataSource<Int, Project>
    typealias ProjectSnapshot = NSDiffableDataSourceSnapshot<Int, Project>
    
    private var projectCollectionView: UICollectionView!
    private var projectDataSource: ProjectDataSource!
    private var projects: [Project] = [] {
        didSet {
            isRecruitProjects = projects.filter { $0.isRecruit }
        }
    }
    private lazy var isRecruitProjects: [Project] = [] {
        didSet {
            makeSnapshot(switchButton.isOn)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCollectionView()
        tabDisappear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FirebaseProject.removeFastSearchProjectListener()
    }
}

extension FastSearchViewController {
    
    // MARK: - API
    
    private func fetchProjects() {
        FirebaseProject.fetchProjectByWantedWorks(work: work) { [weak self] projects in
            self?.projects = projects
        }
    }
    
    // MARK: - Methods
    
    private func configureNavigationBar() {
        let titleLabel = UILabel().label(text: "#\(work)", font: .sub16)
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationItem.titleView = titleLabel
    }
    
    private func collectionViewlayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(146))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.edgeSpacing = .init(leading: .fixed(18), top: .fixed(9), trailing: .fixed(-36), bottom: .fixed(9))
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 36)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureCollectionView() {
        projectCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: collectionViewlayout())
        projectCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        projectCollectionView.backgroundColor = .DarkGray1
        projectCollectionView.delegate = self
        configureCollectionViewDataSource()

        FilterStackView.addArrangedSubview(bottomSheetFilterLabel)
        FilterStackView.addArrangedSubview(switchButton)
        view.addSubview(FilterStackView)
        FilterStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(6)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        view.addSubview(projectCollectionView)
        projectCollectionView.snp.makeConstraints { make in
            make.top.equalTo(FilterStackView.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BottomSheetCell, Project> {
            [unowned self] cell, indexPath, itemIdentifier in

            let project = switchButton.isOn ? isRecruitProjects[indexPath.row] : projects[indexPath.row]
            switch project.isRecruit {
            case true:
                cell.setRecruitTrue()
                cell.titleLabel.text = "             \(project.title)"
            case false:
                cell.setRecruitFalse()
                cell.titleLabel.text = "               \(project.title)"
            }
            
            cell.contentsLabel.text = project.content
            cell.writeDateLabel.text = project.writeDate.projectDate()
            if project.imageUrl == "" {
                cell.configureUIWithNoImage()
            } else {
                guard let url = URL(string: project.imageUrl) else { return }
                cell.projectImageView.sd_setImage(with: url)
                cell.configureUIWithImage()
            }
            FirebaseUser.fetchOtherUser(userID: project.writerId) { user in
                cell.authorLabel.text = user.nickname
                if let url = URL(string: user.profileImageURL) {
                    cell.profileImageView.sd_setImage(with: url)
                } else {
                    cell.profileImageView.image = UIImage(named: "defaultProfile")
                }
            }
        }
        
        projectDataSource = ProjectDataSource(collectionView: projectCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                         for: indexPath,
                                                         item: itemIdentifier)
        })
        
        makeSnapshot()
    }
    
    private func makeSnapshot(_ isOn: Bool = false) {
        var snapshot = ProjectSnapshot()
        snapshot.appendSections([0])
        
        if isOn {
            snapshot.appendItems(isRecruitProjects)
        } else {
            snapshot.appendItems(projects)
        }
        
        projectDataSource.apply(snapshot)
    }
    
    // MARK: - actions
    
    @objc private func clickedSwitchButton(_ sender: UISwitch) {
        makeSnapshot(sender.isOn)
    }
}

// MARK: - UICollectionViewDelegate
extension FastSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        didSendEventClosure?(.showProjectDetail(project: projects[index]))
    }
}
