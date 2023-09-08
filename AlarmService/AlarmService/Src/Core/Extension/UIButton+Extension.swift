//
//  UIButton+Extension.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/08.
//

import UIKit

enum UIButtonType {
    case normal
}

extension UIButton {
    func update(type: UIButtonType) {
        switch type {
        case .normal:
            backgroundColor = .systemBlue
            layer.cornerRadius = 20
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOpacity = 1.0
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowRadius = 6
        }
    }
}
