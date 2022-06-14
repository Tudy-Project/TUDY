//
//  setInterestedJobViewController.swift
//  TUDY
//
//  Created by neuli on 2022/05/26.
//

import UIKit

import SnapKit

class SetInterestedJobViewController: UIViewController {
    
    // MARK: - Properties
    enum Event {
        case next
    }
    var didSendEventClosure: ((Event) -> Void)?

    private lazy var stepStackView = UIStackView().stepStackView(currentStep: step)
    private let guideLabel = UILabel().label(text: "관심 직무를\n선택 해주세요. 👩 ‍💻", font: .sub20)
    private let detailGuideLabel = UILabel().label(text: "관심 직무는 언제든지 마이 페이지에서 수정이 가능해요.", font: .caption11, color: .DarkGray6)
    private let nextButton = UIButton().nextButton()
    private let nextToolbarButton = UIButton().nextButton(text: "다음")
    private let nextToolbar = UIToolbar().toolbar()
    
    // 직무 선택 view
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>
    
    private var jobs: [String] = Jobs.allJobTypes.map { $0.rawValue }
    private var programmerJobs: [String] = Jobs.allProgrammersJobs.map { $0.rawValue }
    private var designerJobs: [String] = Jobs.allDesignerJobs.map { $0.rawValue }
    private var jobCollectionView: UICollectionView!
    private var jobDataSource: DataSource!
    private var detailJobCollectionView: UICollectionView!
    private var detailJobDataSource: DataSource!
    private var selectedJob: JobType?
    private var selectedDetailJobs: [String] = []
    
    private let step = 2
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
    }
}

extension SetInterestedJobViewController {
    
    // MARK: - Methods
    private func configureUI() {
        setNavigationBar()
        view.backgroundColor = .DarkGray1
        
        view.addSubview(stepStackView)
        stepStackView.stepStackViewLayout(view: view)
        
        view.addSubview(guideLabel)
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(115)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        view.addSubview(detailGuideLabel)
        detailGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(guideLabel.snp.bottom).offset(7)
            make.leading.equalTo(view.snp.leading).offset(30)
        }
        
        view.addSubview(jobCollectionView)
        jobCollectionView.snp.makeConstraints { make in
            make.top.equalTo(detailGuideLabel.snp.bottom).offset(69)
            make.leading.equalTo(view.snp.leading).offset(30)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
            make.height.equalTo(56)
        }
        
        view.addSubview(detailJobCollectionView)
        detailJobCollectionView.snp.makeConstraints { make in
            make.top.equalTo(jobCollectionView.snp.bottom).offset(17)
            make.leading.equalTo(view.snp.leading).offset(30)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
            make.height.equalTo(300)
        }
        
        view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(goNext), for: .touchUpInside)
        nextButton.nextButtonLayout(view: view)
    }
    
    private func setNavigationBar() {
        navigationItem.backButtonTitle = ""
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setUser() {
        guard let interestedJob = selectedJob?.rawValue else { fatalError() }
        UserForRegister.shared.interestedJob = interestedJob
        UserForRegister.shared.interestedDetailJobs = selectedDetailJobs
    }
    
    // MARK: CollectionView
    
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
        jobCollectionView = UICollectionView(frame: view.bounds,
                                             collectionViewLayout: collectionViewLayout(height: 56))
        jobCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        jobCollectionView.backgroundColor = .DarkGray1
        jobCollectionView.isScrollEnabled = false
        
        detailJobCollectionView = UICollectionView(frame: view.bounds,
                                                   collectionViewLayout: collectionViewLayout(height: 37))
        detailJobCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        detailJobCollectionView.backgroundColor = .DarkGray1
        detailJobCollectionView.isScrollEnabled = false
        
        configureDataSource()
    }
    
    func configureDataSource() {
        let jobCellRegistration = UICollectionView.CellRegistration<JobCell, String> { [weak self] cell, indexPath, identifier in
            cell.button.setTitle(identifier, for: .normal)
            cell.button.addTarget(self, action: #selector(self?.jobButtonTapped(_:)), for: .touchUpInside)
            cell.contentView.backgroundColor = .DarkGray1
            
            switch identifier {
            case "개발자":
                cell.button.job = .programmer
            case "디자이너":
                cell.button.job = .designer
            default: break
            }
            
            guard let job = cell.button.job else { return }
            if let selectedJob = self?.selectedJob {
                cell.button.backgroundColor = selectedJob == job ? .DarkGray4 : .DarkGray1
            } else {
                cell.button.backgroundColor = .DarkGray1
            }
        }
        
        jobDataSource = DataSource(collectionView: jobCollectionView) {
            collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: jobCellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        var jobSnapshot = Snapshot()
        jobSnapshot.appendSections([0])
        jobSnapshot.appendItems(jobs)
        jobDataSource.apply(jobSnapshot)
        
        let detailJobCellRegistration = UICollectionView.CellRegistration<DetailJobCell, String> {
            [weak self] cell, indexPath, identifier in
            cell.button.setTitle(identifier, for: .normal)
            cell.button.addTarget(self, action: #selector(self?.detailJobButtonTapped(_:)), for: .touchUpInside)
            cell.contentView.backgroundColor = .DarkGray1
            
            if let selectedDetailJobs = self?.selectedDetailJobs {
                if selectedDetailJobs.contains(identifier) {
                    cell.button.backgroundColor = .DarkGray4
                } else {
                    cell.button.backgroundColor = .DarkGray1
                }
            }
        }
        
        detailJobDataSource = DataSource(collectionView: detailJobCollectionView) {
            collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: detailJobCellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        var detailJobSnapshot = Snapshot()
        detailJobSnapshot.appendSections([0])
        detailJobSnapshot.appendItems([])
        detailJobDataSource.apply(detailJobSnapshot)
    }
    
    private func updateJobSnapshot() {
        var snapshot = jobDataSource.snapshot()
        snapshot.reloadItems(jobs)
        jobDataSource.apply(snapshot)
    }
    
    private func updateDetailJobSnapshotWhenTappedJob(job: JobType) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        switch job {
        case .programmer:
            snapshot.appendItems(programmerJobs)
        case .designer:
            snapshot.appendItems(designerJobs)
        }
        detailJobDataSource.apply(snapshot)
    }
    
    private func updateDetailJobSnapshotWhenTappedDetailJob() {
        guard let selectedJob = selectedJob else { return }
        var snapshot = detailJobDataSource.snapshot()
        switch selectedJob {
        case .programmer:
            snapshot.reloadItems(programmerJobs)
        case .designer:
            snapshot.reloadItems(designerJobs)
        }
        detailJobDataSource.apply(snapshot)
    }
    
    // MARK: - Action Methods
    @objc private func goNext() {
        setUser()
        didSendEventClosure?(.next)
    }
    
    @objc private func jobButtonTapped(_ sender: JobButton) {
        // 직업 탭했을 때 selectJob 변경 후 collectionView 업데이트
        guard let job = sender.job else { return }
        if selectedJob != job {
            nextButton.changeIsEnabledFalse()
            selectedDetailJobs = []
        }
        selectedJob = job
        updateDetailJobSnapshotWhenTappedJob(job: job)
        updateJobSnapshot()
    }
    
    @objc private func detailJobButtonTapped(_ sender: DetailJobButton) {
        // 세부 관심분야 탭했을 때 selectedDetailJobs 배열에 추가 or 삭제 후 collectionView 업데이트
        guard let detailJobName = sender.titleLabel?.text else { return }
        if selectedDetailJobs.contains(detailJobName) {
            guard let index = selectedDetailJobs.firstIndex(of: detailJobName) else { return }
            selectedDetailJobs.remove(at: index)
        } else {
            selectedDetailJobs.append(detailJobName)
        }
        updateDetailJobSnapshotWhenTappedDetailJob()
        
        if selectedDetailJobs.isEmpty {
            nextButton.changeIsEnabledFalse()
        } else {
            nextButton.changeIsEnabledTrue()
        }
    }
}
