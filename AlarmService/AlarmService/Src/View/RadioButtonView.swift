//
//  RadioButtonView.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/20.
//

import UIKit
import RxSwift

class RadioButtonView: UIView {
    
    private let disposeBag = DisposeBag()
    var selected: Bool = false
    
    private var iconImage: UIImageView = {
        let image = UIImageView(image: nil)
        return image
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var button: UIButton = {
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
        selected = true
        iconImage.image = UIImage(named: "select")
    }
    
    func unSelect() {
        selected = false
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
        }.disposed(by: disposeBag)
    }
    
    func isButton(_ button: UIButton) -> Bool {
        return self.button == button
    }
}
