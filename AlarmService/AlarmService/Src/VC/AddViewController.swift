//
//  AddViewController.swift
//  AlarmService
//
//  Created by 김형진 on 2023/08/18.
//

import UIKit
import RxSwift
import UserNotifications

struct AddInitData {
    let editMode: Bool
    let data: SaveData?
}

class AddViewController: BaseVC<AddInitData> {
    
    private let disposeBag = DisposeBag()
    let viewModel: AddVM
    
    private let sv: UIScrollView = {
        let sv = UIScrollView()
        sv.scrollIndicatorInsets = UIEdgeInsets.zero
        return sv
    }()
    
    private let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.preferredDatePickerStyle = .inline
        dp.datePickerMode = .dateAndTime
        dp.locale = .autoupdatingCurrent
        return dp
    }()
    
    private let descLabel: UILabel = {
        let lb = UILabel()
        lb.text = "description"
        return lb
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = .black
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.minimumFontSize = 17
        tf.adjustsFontSizeToFitWidth = true
        tf.backgroundColor = .white
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.orange.cgColor
        tf.layer.cornerRadius = 10
        tf.addLeftPadding()
        tf.addRightPadding()
        return tf
    }()
    
    private let addButtonView: UIShadowButtonView = {
        let view = UIShadowButtonView()
        view.button.setTitle("Add", for: .normal)
        view.button.update(type: .normal)
        return view
    }()
    
    private let closeButtonView: UIShadowButtonView = {
        let view = UIShadowButtonView()
        view.button.setTitle("Close", for: .normal)
        view.button.update(type: .normal)
        return view
    }()
    
    required init<T>(initDataProvider: T) where AddInitData == T.CustomInitData, T : BaseVCInitDataProviderType {
        self.viewModel = AddVM(initData: initDataProvider.customInitData)
        super.init(initDataProvider: initDataProvider)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        if viewModel.editMode {
            if let data = viewModel.editData.value {
                let formatter = DateFormatter()
                formatter.dateFormat = Constants.DateFormat
                if let date = formatter.date(from: data.dateStr) {
                    self.datePicker.date = date
                }
                self.textField.text = data.desc
            }
            addButtonView.button.setTitle("Update", for: .normal)
        } else {
            addButtonView.button.setTitle("Add", for: .normal)
        }
        self.requestNotificationAuthorization()
        
        action()
        bind()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(sv)
        sv.addSubview(datePicker)
        sv.addSubview(descLabel)
        sv.addSubview(textField)
        sv.addSubview(addButtonView)
        sv.addSubview(closeButtonView)
        
        sv.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.width.equalToSuperview()
        }
        datePicker.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.width.equalTo(view.snp.width).offset(-40)
            make.top.equalToSuperview().inset(10)
            make.height.equalTo(380)
        }
        descLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(datePicker.snp.bottom).offset(20)
        }
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(descLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        addButtonView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.height.equalTo(40)
        }
        closeButtonView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(addButtonView.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func action() {
        addButtonView.button.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            if self.viewModel.editMode {
                if let data = self.viewModel.editData.value, let text = self.textField.text, !text.isEmpty {
                    self.addNotification(date: datePicker.date, title: "alarm", desc: text, cbComplete: {
                        if SaveDataManager.shared.delete(id: data.id) {
                            self.closeVC()
                        }
                    })
                } else {
                    PopupVC.showAlert(vc: self, title: "알림", message: "상세 정보를 입력하세요")
                }
            } else {
                if let text = self.textField.text, !text.isEmpty {
                    self.addNotification(date: datePicker.date, title: "alarm", desc: text)
                } else {
                    PopupVC.showAlert(vc: self, title: "알림", message: "상세 정보를 입력하세요")
                }
            }
        }.disposed(by: disposeBag)
        
        closeButtonView.button.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            self.closeVC()
        }.disposed(by: disposeBag)
    }
    
    private func bind() {
    }
    
    private func closeVC() {
        NotificationCenter.default.post(name: Constants.RefreshAlarms, object: nil, userInfo: nil)
        self.dismiss(animated: true)
    }
}
