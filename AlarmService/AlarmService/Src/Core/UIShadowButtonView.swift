//
//  UIShadowButton.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/13.
//

import UIKit

class UIShadowButtonView: UIView {
    let button = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
