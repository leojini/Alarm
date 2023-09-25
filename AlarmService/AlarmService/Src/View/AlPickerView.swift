//
//  AlPickerView.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/20.
//

import UIKit
import RxSwift
import SnapKit

typealias SelectPickerCB = (Bool, Int) -> Void

struct AlPickerData {
    let name: String
    let number: Int
}

class AlPickerView: UIView {
    
    private let disposeBag = DisposeBag()
    private var datas: [AlPickerData] = []
    private var selectPickerCB: SelectPickerCB?
    private var index = 0
    
    private let bgView = UIView()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        let color = UIColor(hexCode: "6499e9")
        button.setBackgroundColor(color, for: .normal)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        let color = UIColor(hexCode: "213555")
        button.setBackgroundColor(color, for: .normal)
        return button
    }()
    
    private let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        picker.delegate = self
        picker.dataSource = self
        setupSubviews()
        action()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ datas: [AlPickerData]) {
        self.datas = datas
        picker.reloadAllComponents()
    }
    
    func updateSelectCB(_ cb: @escaping SelectPickerCB) {
        selectPickerCB = cb
    }
    
    private func setupSubviews() {
        self.backgroundColor = .clear
        bgView.backgroundColor = .gray
        bgView.alpha = 0.8
        
        let buttonBgView = UIView()
        buttonBgView.backgroundColor = .white
        
        addSubview(bgView)
        addSubview(buttonBgView)
        buttonBgView.addSubview(okButton)
        buttonBgView.addSubview(cancelButton)
        addSubview(picker)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        picker.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
        buttonBgView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(picker.snp.top)
            make.height.equalTo(50)
        }
        okButton.snp.makeConstraints { make in
            make.left.top.equalTo(0)
            make.height.equalTo(50)
            make.width.equalTo(Constants.screenWidth * 0.5)
        }
        cancelButton.snp.makeConstraints { make in
            make.left.equalTo(Constants.screenWidth * 0.5)
            make.top.equalTo(0)
            make.height.equalTo(50)
            make.width.equalTo(Constants.screenWidth * 0.5)
        }
    }
    
    private func action() {
        bgView.isUserInteractionEnabled = true
        let ges = UITapGestureRecognizer(target: self, action: #selector(tapBgView))
        ges.numberOfTapsRequired = 1
        bgView.addGestureRecognizer(ges)
        
        okButton.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            selectPickerCB?(true, self.index)
            self.removeFromSuperview()
        }.disposed(by: disposeBag)
        
        cancelButton.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            self.tapBgView()
        }.disposed(by: disposeBag)
    }
    
    @objc func tapBgView() {
        selectPickerCB?(false, self.index)
        self.removeFromSuperview()
    }
}

extension AlPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datas[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        index = row
    }
}
