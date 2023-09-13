//
//  ViewController.swift
//  AlarmService
//
//  Created by 김형진 on 2023/08/18.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private var datas: [SaveData] = []
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Your alarms"
        lb.textColor = .purple
        lb.font = UIFont.boldSystemFont(ofSize: 24)
        return lb
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.bouncesZoom = false
        return tableView
    }()
    
    private let addButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add", for: .normal)
        btn.update(type: .normal)
        return btn
    }()
    
    private let editButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Edit", for: .normal)
        btn.update(type: .normal)
        return btn
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Delete", for: .normal)
        btn.update(type: .normal)
        return btn
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Constants.RefreshAlarms, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmItemCell.self, forCellReuseIdentifier: "AlarmItemCell")
        
        setupViews()
        action()
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: Constants.RefreshAlarms, object: nil)
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        let sv = UIStackView(arrangedSubviews: [addButton, editButton, deleteButton])
        sv.axis = .horizontal
        sv.spacing = 10.0
        sv.alignment = .leading
        sv.distribution = .fill
        view.addSubview(sv)
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
        }
        sv.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.bottom.equalTo(sv.snp.top).offset(-20)
        }
    }
    
    private func action() {
        addButton.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            let customInitData = AddInitData(editMode: false, data: nil)
            let dataProvider = BaseVCInitDataProvider(customInitData: customInitData)
            let vc = AddViewController(initDataProvider: dataProvider)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
        
        editButton.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            let customInitData = AddInitData(editMode: true, data: SaveDataManager.shared.getSelectedData())
            let dataProvider = BaseVCInitDataProvider(customInitData: customInitData)
            let vc = AddViewController(initDataProvider: dataProvider)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
        
        deleteButton.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            if let data = datas.first(where: { $0.option == true }) {
                PopupVC.showAlert(vc: self, title: "알림", message: "'\(data.desc)' 스케줄에서 삭제하시겠습니까?", okHandler: {
                    if SaveDataManager.shared.delete(id: data.id) {
                        PopupVC.showAlert(vc: self, title: "알림", message: "'\(data.desc)' 스케줄에서 삭제했습니다.") {
                            self.refresh()
                        }
                    }
                }, cancelHandler: {
                    
                })
            } else {
                PopupVC.showAlert(vc: self, title: "알림", message: "아이템을 먼저 선택해주세요.")
            }
        }.disposed(by: disposeBag)
    }
    
    @objc func refresh() {
        datas = SaveDataManager.shared.getList()
        tableView.reloadData()
        
        // Edit, Delete 버튼 활성화 체크
        if datas.first(where: { $0.option == true }) != nil {
            editButton.isEnabled = true
            deleteButton.isEnabled = true
        } else {
            editButton.isEnabled = false
            deleteButton.isEnabled = false
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = datas[indexPath.row]
        if let cell: AlarmItemCell = tableView.dequeueReusableCell(withIdentifier: "AlarmItemCell") as? AlarmItemCell {
            cell.setData(data: data, index: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datas[indexPath.row]
        if data.option == false {
            var tempDatas: [SaveData] = []
            for var d in datas {
                d.option = (data.id == d.id)
                tempDatas.append(d)
            }
            SaveDataManager.shared.update(datas: tempDatas)
            refresh()
        }
    }
}
