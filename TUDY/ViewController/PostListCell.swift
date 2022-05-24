//
//  PostCollectionViewCell.swift
//  TUDY
//
//  Created by jamescode on 2022/05/20.
//

import UIKit
import SnapKit

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
    
    // MARK: - Properties
    private var postData: Post?
    
    lazy var postTitle: UILabel = {
        let Label = UILabel()
        Label.adjustsFontForContentSizeCategory = true
        Label.numberOfLines = 2
        Label.textColor = .white
        Label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        Label.text = postData?.title
        return Label
    }()
    
    lazy var postDesc: UILabel = {
        let Label = UILabel()
        Label.adjustsFontForContentSizeCategory = true
        Label.numberOfLines = 1
        Label.textColor = .white
        Label.font = UIFont.preferredFont(forTextStyle: .caption1)
        Label.text = postData?.desc
        return Label
    }()
    
    lazy var starButton: UIButton = {
        let Button = UIButton()
        let starImage = UIImage(systemName: "star")
        Button.setImage(starImage, for: .normal)
        return Button
    }()
    
    lazy var starCount: UILabel = {
        let Label = UILabel()
        Label.textColor = .white
        Label.font = UIFont.preferredFont(forTextStyle: .caption1)
        Label.text = postData?.starCount
        return Label
    }()
    
    lazy var authorName: UILabel = {
        let Label = UILabel()
        Label.textColor = .white
        Label.font = UIFont.preferredFont(forTextStyle: .body)
        Label.text = postData?.writer
        return Label
    }()
    
    lazy var authorImage: UIImageView = {
        let ImageView = UIImageView()
        ImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        ImageView.loadFrom(URLAddress: postData!.imageUrl)
        ImageView.contentMode = .scaleAspectFit
        ImageView.layer.cornerRadius = ImageView.frame.width / 2
        ImageView.clipsToBounds = true
        return ImageView
    }()
    
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
        //        guard postTypeConstraints == nil else {
        //            return
        //        }
        
        contentView.addSubview(postTitle)
        contentView.addSubview(postDesc)
        contentView.addSubview(starButton)
        contentView.addSubview(starCount)
        contentView.addSubview(authorImage)
        contentView.addSubview(authorName)
        
        
        postTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().multipliedBy(0.83)
        }
        
        postDesc.snp.makeConstraints { make in
            make.top.equalTo(postTitle.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        starButton.snp.makeConstraints { make in
            make.top.equalTo(postDesc.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        starCount.snp.makeConstraints { make in
            make.top.equalTo(postDesc.snp.bottom).offset(15)
            make.leading.equalTo(starButton.snp.trailing).offset(5)
        }
        
        authorImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-30)
            make.width.height.equalTo(50)
        }
        
        authorName.snp.makeConstraints { make in
            make.top.equalTo(authorImage.snp.bottom).offset(10)
            make.centerX.equalTo(authorImage)
        }
    }
    
    override func  updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
        //        var content = defaultPostConfiguration().updated(for: state)
        //
        //        content.image = urlToImage(state.postData?.imageLink ?? "")
        //        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
        //        content.text = state.postData?.title
        //        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        //
        //        postListContentView.configuration = content
        //        postTypeLabel.text = state.postData?.postType ?? "1"
    }
}

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}
