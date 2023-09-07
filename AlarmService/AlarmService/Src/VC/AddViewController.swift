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
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    required init<T>(initDataProvider: T) where AddInitData == T.CustomInitData, T : BaseVCInitDataProviderType {
        self.viewModel = AddVM(initData: initDataProvider.customInitData)
        super.init(initDataProvider: initDataProvider)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.editMode {
            if let data = viewModel.editData.value {
                let formatter = DateFormatter()
                formatter.dateFormat = Constants.DateFormat
                if let date = formatter.date(from: data.dateStr) {
                    self.datePicker.date = date
                }
                self.textField.text = data.desc
            }
            addButton.setTitle("Update", for: .normal)
        } else {
            addButton.setTitle("Add", for: .normal)
        }
        self.requestNotificationAuthorization()
        
        bind()
    }
    
    func bind() {
    }
    
    func closeVC() {
        NotificationCenter.default.post(name: Constants.RefreshAlarms, object: nil, userInfo: nil)
        self.dismiss(animated: true)
    }
    
    @IBAction func onClose(_ sender: Any) {
        closeVC()
    }
    
    @IBAction func onAdd(_ sender: Any) {
        print("add")
        if viewModel.editMode {
            if let data = viewModel.editData.value, let text = textField.text, !text.isEmpty {
                self.sendNotification(date: datePicker.date, title: "alarm", desc: text, cbComplete: {
                    if SaveDataManager.shared.delete(id: data.id) {
                        self.closeVC()
                    }
                })
            } else {
                PopupVC.showAlert(vc: self, title: "알림", message: "상세 정보를 입력하세요")
            }
        } else {
            if let text = textField.text, !text.isEmpty {
                self.sendNotification(date: datePicker.date, title: "alarm", desc: text)
            } else {
                PopupVC.showAlert(vc: self, title: "알림", message: "상세 정보를 입력하세요")
            }
        }
    }
}
