//
//  UIFont+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/05/24.
//

import UIKit

extension UIFont {

    static var title: UIFont { UIFont(name: "AppleSDGothicNeoEB00", size: 40) ?? UIFont.systemFont(ofSize: 40, weight: .bold) }
    static var logo26: UIFont { UIFont(name: "AppleSDGothicNeoEB00", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .bold) }
    static var sub20: UIFont { UIFont(name: "AppleSDGothicNeoEB00", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold) }
    static var sub16: UIFont { UIFont(name: "AppleSDGothicNeoEB00", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold) }
    static var sub14: UIFont { UIFont(name: "AppleSDGothicNeoEB00", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold) }
    static var body16: UIFont { UIFont.systemFont(ofSize: 16, weight: .medium) }
    static var body14: UIFont { UIFont.systemFont(ofSize: 14, weight: .medium) }
    static var caption12: UIFont { UIFont.systemFont(ofSize: 12, weight: .medium) }
    static var caption11: UIFont { UIFont.systemFont(ofSize: 11, weight: .medium) }
    static var caption8: UIFont { UIFont.systemFont(ofSize: 8, weight: .medium) }
}
