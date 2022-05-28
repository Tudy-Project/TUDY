//
//  PostCollectionViewCell.swift
//  TUDY
//
//  Created by jamescode on 2022/05/20.
//

import UIKit
import SnapKit

class PostListCell: UICollectionViewListCell {
    
    // MARK: - Properties
    private var postData: Post?
    
    lazy var postTitle: UILabel = {
        let Label = UILabel()
        Label.adjustsFontForContentSizeCategory = true
        Label.numberOfLines = 2
        Label.textColor = .black
        Label.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        Label.text = postData?.title
        return Label
    }()
    
    lazy var postDesc: UILabel = {
        let Label = UILabel()
        Label.adjustsFontForContentSizeCategory = true
        Label.numberOfLines = 1
        Label.textColor = .systemGray2
        Label.font = UIFont.preferredFont(forTextStyle: .caption1)
        Label.text = postData?.desc
        return Label
    }()
  
    lazy var heartButton: UIButton = {
        let Button = UIButton()
        let heartImage = UIImage(systemName: "heart")
        Button.setImage(heartImage, for: .normal)
        return Button
    }()
    
    lazy var heartCount: UILabel = {
        let Label = UILabel()
        Label.textColor = .black
        Label.font = UIFont.preferredFont(forTextStyle: .caption1)
        Label.text = postData?.heartCount
        return Label
    }()
    
    lazy var authorName: UILabel = {
        let Label = UILabel()
        Label.textColor = .black
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
    
    //cell의 상태(state)를 캡슐화한 객체
    //cell의 상태라고 하면 selected, focused, disabled의 상태인지 등을 나타낸다.
    //cell의 configuration state를 얻을 수 있다.
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.postData = self.postData
        return state
    }
}

extension PostListCell {
    
    func update(with newPostData: Post) {
        guard postData != newPostData else {
            return
        }
        postData = newPostData
        setNeedsUpdateConfiguration()
    }
    
    func setupViewsIfNeeded() {
        
        contentView.addSubview(postTitle)
        contentView.addSubview(postDesc)
        contentView.addSubview(heartButton)
        contentView.addSubview(heartCount)
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
        
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(postDesc.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        heartCount.snp.makeConstraints { make in
            make.top.equalTo(postDesc.snp.bottom).offset(15)
            make.leading.equalTo(heartButton.snp.trailing).offset(5)
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
    
    //UICellConfigurationState 객체를 직접 생성해주지는 않는다. configuration state를 갖기 위해서는 cell의 하위 클래스에서 updateConfiguration(using:) 메서드를 재정의하여 state 파라미터를 써주면 된다.
    override func  updateConfiguration(using state: UICellConfigurationState) {
        setupViewsIfNeeded()
//                var content = defaultPostConfiguration().updated(for: state)
//
//                content.image = urlToImage(state.postData?.imageLink ?? "")
//                content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
//                content.text = state.postData?.title
//                content.textProperties.font = .preferredFont(forTextStyle: .headline)
//
//                postListContentView.configuration = content
    }
}

private extension UIConfigurationStateCustomKey {
    static let post = UIConfigurationStateCustomKey("post")
}

//뷰의 상태(state)를 캡슐화하여 가지고 있는 객체
extension UIConfigurationState {
    var postData: Post?{
        //custom key를 가지고 state
        get{ return self[.post]as? Post}
        //키에 해당하는 value에 새로운 newValue를 할당
        set{ self[.post] = newValue }
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
