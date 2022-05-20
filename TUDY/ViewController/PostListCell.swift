//
//  PostCollectionViewCell.swift
//  TUDY
//
//  Created by jamescode on 2022/05/20.
//

import UIKit

private extension UIConfigurationStateCustomKey {
    static let post = UIConfigurationStateCustomKey("post")
}

extension UIConfigurationState {
    var postData: Post?{
        get{ return self[.post]as? Post}
        set{ self[.post] = newValue }
    }
}

class PostListCell: UICollectionViewListCell {
    private var postData: Post?
    
    //list 기반의 contentView를 반환하는 메서드
    private func defaultPostConfiguration() -> UIListContentConfiguration {
        return .subtitleCell()
    }
    
    private let postTypeLabel = UILabel()
    private var postTypeConstraints: (leading: NSLayoutConstraint, trailing:NSLayoutConstraint)?
    //list 기반의 contentView를 만든다
    private lazy var postListContentView = UIListContentView(configuration: defaultPostConfiguration())
    
    func update(with newPostData: Post) {
        guard postData != newPostData else {
            return
        }
        postData = newPostData
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.postData = self.postData
        return state
    }
}

extension PostListCell {
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
        
        NSLayoutConstraint.activate([
            postListContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postListContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            postListContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postTypeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            constraints.leading,
            constraints.trailing
        ])
        
        postTypeConstraints = constraints

    }
    
    override func  updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        var content = defaultPostConfiguration().updated(for: state)
        
        content.image = urlToImage(state.postData?.imageLink ?? "")
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        content.text = state.postData?.title
        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        
        postListContentView.configuration = content
        postTypeLabel.text = state.postData?.postType ?? "1"
    }
}

extension PostListCell {
    func urlToImage(_ urlString: String) -> UIImage? {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
}
