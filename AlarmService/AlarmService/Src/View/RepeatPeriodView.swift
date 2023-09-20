//
//  RepeatPeriodView.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/19.
//

import UIKit

class RadioButtonView: UIView {
    
    private var iconImage: UIImageView = {
        let image = UIImageView(image: nil)
        return image
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private var button: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        unSelect()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(iconImage)
        addSubview(label)
        addSubview(button)
        iconImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(20)
        }
        label.snp.makeConstraints { make in
            make.left.equalTo(iconImage.snp.right).offset(8)
            make.top.equalTo(iconImage)
            make.right.equalToSuperview()
        }
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateIconImageWH(width: Double, height: Double) {
        iconImage.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(height)
        }
    }
    
    func select() {
        iconImage.image = UIImage(named: "select")
    }
    
    func unSelect() {
        iconImage.image = UIImage(named: "unSelect")
    }
    
    func setText(_ text: String) {
        label.text = text
    }
    
    func setButtonCB(cbComplete: @escaping (_ btn: UIButton) -> Void) {
        button.rx.tap.bind { [weak self] in
            if let btn = self?.button {
                cbComplete(btn)
            }
        }
    }
    
    func isButton(_ button: UIButton) -> Bool {
        return self.button == button
    }
}

// 반복 여부, 주기(분), 횟수(1 ~ 5번)
class RepeatPeriodView: UIView {
    // 반복 유, 무 버튼(토글) 스위치
    // 주기(분) 선택 picker(1~15분)
    // 횟수(번) 선택 picker(1~5번)
    
    final let buttonHeight: Double = 25
    
    private let radioButtonViews: [RadioButtonView] = {
        var views: [RadioButtonView] = []
        for i in (0..<2) {
            let view = RadioButtonView(frame: .zero)
            if i == 0 {
                view.setText("반복함 aaaaa bbbbbb cccccc")
            } else {
                view.setText("반복안함")
            }
            views.append(view)
        }
        return views
    }()
    
    private func onClickButton(_ button: UIButton) {
        for view in radioButtonViews {
            if view.isButton(button) {
                view.select()
            } else {
                view.unSelect()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
        action()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        let sv = UIStackView(arrangedSubviews: radioButtonViews)
        sv.axis = .horizontal
        sv.spacing = 10.0
        sv.alignment = .leading
        sv.distribution = .fillEqually
        addSubview(sv)
        
        sv.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.buttonHeight * 2 + 10)
        }
        for view in radioButtonViews {
            view.updateIconImageWH(width: self.buttonHeight, height: self.buttonHeight)
        }
    }
    
    private func action() {
        for view in radioButtonViews {
            view.setButtonCB { btn in
                self.onClickButton(btn)
            }
        }
    }
}
