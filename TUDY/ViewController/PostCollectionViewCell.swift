//
//  PostCollectionViewCell.swift
//  TUDY
//
//  Created by jamescode on 2022/05/20.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    private var postData: Post?
    
    //list 기반의 contentView를 반환하는 메서드
    private func defaultPostConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    //list rlqksdml contentView를 만든다
    private lazy var postListContentView = UIListContentView(configuration: defaultPostConfiguration())
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.postData = self.accessibilityActivationPoint.animatableData
        return state
    }
}


extension PostCollectionViewCell {
    func setupViewsIfNeeded() {
        //커스텀View에 대한 제약이 기존에 주어지면 다시 layout을 적용하지 않도록함
        guard postTypeConstraints == nil else {
            return
        }
        
        [postListContentView, postTypeLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let constraints = (
            leading: postTypeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: postListContentView.trailingAnchor),
            trailing: postTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        )
        
        NSLayoutConstraint.activate([ postListContentView.topAnchor.constraint(equalTo: contentView.topAnchor), animalListContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor), animalListContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), animalTypeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), constraints.leading, constraints.trailing ]) postTypeConstraints = constraints

    }
}
