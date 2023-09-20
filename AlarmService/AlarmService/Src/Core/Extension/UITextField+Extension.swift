//
//  UITextField+Extension.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/08.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ width: Double = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightPadding(_ width: Double = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
}
