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
    
        let titleLabel = UILabel()
        let descLabel = UILabel()
    
        let starButton : UIButton = {
         let starButton = UIButton()
         let starImage = UIImage(systemName: "star")
         starButton.setImage(starImage, for: .normal)
         return starButton
        }()

        let starLabel = UILabel()
     let postImage: UIImageView = {
         let postImage = UIImageView()
         postImage.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
         return postImage
    }()
        let writerLabel = UILabel()
    
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
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        starButton.translatesAutoresizingMaskIntoConstraints = false
        starLabel.translatesAutoresizingMaskIntoConstraints = false
        postImage.translatesAutoresizingMaskIntoConstraints = false
        writerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.adjustsFontForContentSizeCategory = true
        descLabel.adjustsFontForContentSizeCategory = true
        starLabel.adjustsFontForContentSizeCategory = true
        writerLabel.adjustsFontForContentSizeCategory = true
        
        titleLabel.numberOfLines = 0
        descLabel.numberOfLines = 1
        
        
        titleLabel.textColor = .white
        descLabel.textColor = .white
        starLabel.textColor = .white
        writerLabel.textColor = .white
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        descLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        starLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        writerLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        titleLabel.text = postData?.title
        descLabel.text = postData?.desc
        starLabel.text = postData?.starCount
        
        postImage.loadFrom(URLAddress: postData!.imageUrl)
        postImage.contentMode = .scaleAspectFit
        postImage.layer.cornerRadius = postImage.frame.width / 2
        postImage.clipsToBounds = true
        
        writerLabel.text = postData?.writer
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(starButton)
        contentView.addSubview(starLabel)
        contentView.addSubview(postImage)
        contentView.addSubview(writerLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            starButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 10),
            starButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            starLabel.leadingAnchor.constraint(equalTo: starButton.trailingAnchor, constant: 5),
            starLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 15),
            postImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            postImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            postImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            postImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 130),
            postImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 30),
            writerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 130),
            writerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 30)
        ])
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
