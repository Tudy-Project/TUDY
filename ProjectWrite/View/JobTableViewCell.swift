//
//  JobTableViewCell.swift
//  TUDY
//
//  Created by jamescode on 2022/05/29.
//

import UIKit

class JobTableViewCell: UITableViewCell {

    static let identifier = "JobTableViewCell"
    
    // MARK: - Properties
       
        let tableLabel : UILabel = {
           let label = UILabel()
            label.text = "개발"
           label.font = .systemFont(ofSize: 15, weight: .regular)
           return label
       }()
    
    // MARK: - configureUI
        
        func configureUI() {
            addSubview(tableLabel)
            
            tableLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(16)
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
