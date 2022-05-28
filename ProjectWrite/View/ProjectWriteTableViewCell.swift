//
//  ProjectWriteTableViewCell.swift
//  TUDY
//
//  Created by jamescode on 2022/05/28.
//

import UIKit

class ProjectWriteTableViewCell: UITableViewCell {
    
    static let identifier = "TableViewCell"
    
    // MARK: - Properties
       
        let tableLabel : UILabel = {
           let label = UILabel()
           label.font = .systemFont(ofSize: 15, weight: .regular)
           return label
       }()
    
        let chevronDown: UIImageView = {
            let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
            return imageView
        }()
    
    // MARK: - configureUI
        
        func configureUI() {
            addSubview(tableLabel)
            addSubview(chevronDown)
            
            tableLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(16)
            }
            
            chevronDown.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(-16)
            }
            
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
