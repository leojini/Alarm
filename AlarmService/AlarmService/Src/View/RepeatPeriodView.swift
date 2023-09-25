//
//  RepeatPeriodView.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/19.
//

import UIKit
import RxSwift

typealias SelectPeriodDataCB = (Int, Int) -> Void

protocol RepeatPeriodViewDelegate: UIViewController {
    func selectPeriod(data: AlPickerData)
    func selectCount(data: AlPickerData)
}

// 반복 여부, 주기(분), 횟수(번)
class RepeatPeriodView: UIView {
    // 반복 유, 무 버튼(토글) 스위치
    // 주기(분) 선택 picker(1~30분)
    // 횟수(번) 선택 picker(1~10번)
    
    weak var delegate: RepeatPeriodViewDelegate?
    private let disposeBag = DisposeBag()
    static let buttonHeight: Double = 25
    static let peroids: [AlPickerData] = [.init(name: "1분", number: 1), .init(name: "5분", number: 5), .init(name: "10분", number: 10), .init(name: "15분", number: 15), .init(name: "30분", number: 30)]
    static let counts: [AlPickerData] = [.init(name: "1회", number: 1), .init(name: "3회", number: 3), .init(name: "5회", number: 5), .init(name: "10회", number: 10)]
    private var period: Int = 0
    private var count: Int = 0
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10.0
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    private let radioButtonViews: [RadioButtonView] = {
        var views: [RadioButtonView] = []
        for i in (0..<2) {
            let view = RadioButtonView(frame: .zero)
            if i == 0 {
                view.setText("반복함")
            } else {
                view.setText("반복안함")
            }
            views.append(view)
        }
        return views
    }()
    
    private let periodButtonView: UIShadowButtonView = {
        let view = UIShadowButtonView()
        view.button.setTitle("주기", for: .normal)
        view.button.update(type: .normal)
        return view
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "분"
        return label
    }()
    
    private let countButtonView: UIShadowButtonView = {
        let view = UIShadowButtonView()
        view.button.setTitle("횟수", for: .normal)
        view.button.update(type: .normal)
        return view
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "회"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubview()
        action()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubview() {
        let svRepeat = UIStackView(arrangedSubviews: radioButtonViews)
        svRepeat.axis = .horizontal
        svRepeat.spacing = 10.0
        svRepeat.alignment = .leading
        svRepeat.distribution = .fill
        
        let svPeriod = UIStackView(arrangedSubviews: [periodButtonView, periodLabel])
        svPeriod.axis = .horizontal
        svPeriod.spacing = 10.0
        svPeriod.alignment = .leading
        svPeriod.distribution = .fillEqually
        
        let svCount = UIStackView(arrangedSubviews: [countButtonView, countLabel])
        svCount.axis = .horizontal
        svCount.spacing = 10.0
        svCount.alignment = .leading
        svCount.distribution = .fillEqually
        
        stackView.addArrangedSubview(svRepeat)
        stackView.addArrangedSubview(svPeriod)
        stackView.addArrangedSubview(svCount)
        addSubview(stackView)
        
        let halfWidth = Constants.screenWidth * 0.5 - 40
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        radioButtonViews[0].snp.makeConstraints { make in
            make.width.equalTo(halfWidth)
        }
        periodButtonView.snp.makeConstraints { make in
            make.width.equalTo(halfWidth)
            make.height.equalTo(40)
        }
        periodLabel.snp.makeConstraints { make in
            make.centerY.equalTo(periodButtonView)
        }
        countButtonView.snp.makeConstraints { make in
            make.width.equalTo(halfWidth)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(countButtonView)
        }
        
        for view in radioButtonViews {
            view.updateIconImageWH(width: RepeatPeriodView.buttonHeight, height: RepeatPeriodView.buttonHeight)
        }
    }
    
    private func action() {
        for (index, view) in radioButtonViews.enumerated() {
            view.setButtonCB { btn in
                self.onClickButton(index: index, button: btn)
            }
        }
        
        periodButtonView.button.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            let pv = AlPickerView(frame: .zero)
            pv.update(RepeatPeriodView.peroids)
            pv.updateSelectCB { success, index in
                if success {
                    let data = RepeatPeriodView.peroids[index]
                    self.updatePeriodData(data: data)
                    self.delegate?.selectPeriod(data: data)
                }
            }
            self.delegate?.view.addSubview(pv)
            pv.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }.disposed(by: disposeBag)
        
        countButtonView.button.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            let pv = AlPickerView(frame: .zero)
            pv.update(RepeatPeriodView.counts)
            pv.updateSelectCB { success, index in
                if success {
                    let data = RepeatPeriodView.counts[index]
                    self.updateCountData(data: data)
                    self.delegate?.selectCount(data: data)
                }
            }
            self.delegate?.view.addSubview(pv)
            pv.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }.disposed(by: disposeBag)
    }
    
    func setEnablePeriod(_ enable: Bool) {
        periodButtonView.button.isEnabled = enable
        periodLabel.textColor = (enable) ? .black: .lightGray
    }
    
    func setEnableCount(_ enable: Bool) {
        countButtonView.button.isEnabled = enable
        countLabel.textColor = (enable) ? .black: .lightGray
    }
    
    func updatePeriodData(data: AlPickerData) {
        self.period = data.number
        self.periodLabel.text = data.name
    }
    
    func updateCountData(data: AlPickerData) {
        self.count = data.number
        self.countLabel.text = data.name
    }
    
    func updatePeriodButton(enableRepeat: Bool) {
        if enableRepeat {
            onClickButton(index: 0, button: radioButtonViews[0].button)
        } else {
            onClickButton(index: 1, button: radioButtonViews[1].button)
        }
    }
    
    private func onClickButton(index: Int, button: UIButton) {
        for view in radioButtonViews {
            if view.isButton(button) {
                view.select()
            } else {
                view.unSelect()
            }
        }
        
        if index == 0 { // 반복함
            setEnablePeriod(true)
            setEnableCount(true)
            
            // 한 개도 선택된 것이 없다면
            if period == 0, count == 0 {
                // 최소 주기, 횟수를 선택한다.
                updatePeriodData(data: RepeatPeriodView.peroids[0])
                updateCountData(data: RepeatPeriodView.counts[0])
            }
            
        } else {
            setEnablePeriod(false)
            setEnableCount(false)
        }
    }
    
    func isRepeat() -> Bool {
        if let index = radioButtonViews.firstIndex(where: { $0.selected }), index == 0 {
            return true
        }
        return false
    }
    
    func getRepeatData(_ cb: @escaping SelectPeriodDataCB) {
        cb(period, count)
    }
}
