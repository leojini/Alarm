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
    func update(type: UIButtonType, cornerRadius: CGFloat = 20.0) {
        switch type {
        case .normal:
            setBackgroundColor(.systemGreen, for: .normal)
            setBackgroundColor(.lightGray, for: .selected)
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
