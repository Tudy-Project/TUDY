//
//  SubwayCell.swift
//  TUDY
//
//  Created by neuli on 2022/05/30.
//

import UIKit

import SnapKit

fileprivate extension UIConfigurationStateCustomKey {
    static let subway = UIConfigurationStateCustomKey("subway")
}

private extension UICellConfigurationState {
    var subway: Subway? {
        set { self[.subway] = newValue }
        get { return self[.subway] as? Subway }
    }
}

class SubwayCell: UICollectionViewListCell {
    var subway: Subway? = nil
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.subway = self.subway
        return state
    }
}

class SubwayListCell: SubwayCell {
    
    private func defaultListContentConfiguration() -> UIListContentConfiguration { return .cell() }
    private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
    
    private let subwayLabel = UILabel()
    private let icon = UIImageView()
    
}

extension SubwayListCell {
    
    private func configureUI() {
        contentView.addSubview(subwayLabel)
        subwayLabel.snp.makeConstraints { make in
            // make.
        }
        
        contentView.addSubview(icon)
    }
}
