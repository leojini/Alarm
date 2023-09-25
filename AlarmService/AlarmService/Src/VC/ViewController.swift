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
    var indexPath: IndexPath?
    
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
        tableView.alwaysBounceVertical = false
        tableView.alwaysBounceHorizontal = false
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        tableView.register(AlarmItemCell.self, forCellReuseIdentifier: "AlarmItemCell")
        return tableView
    }()
    
    private let addButtonView: UIShadowButtonView = {
        let view = UIShadowButtonView()
        view.button.setTitle("Add", for: .normal)
        view.button.update(type: .normal)
        return view
    }()
    
    private let editButtonView: UIShadowButtonView = {
        let view = UIShadowButtonView()
        view.button.setTitle("Edit", for: .normal)
        view.button.update(type: .normal)
        return view
    }()
    
    private let deleteButtonView: UIShadowButtonView = {
        let view = UIShadowButtonView()
        view.button.setTitle("Delete", for: .normal)
        view.button.update(type: .normal)
        return view
    }()
    
    private let settingButtonView: UIShadowButtonView = {
        let view = UIShadowButtonView()
        view.button.setTitle("Setting", for: .normal)
        view.button.update(type: .normal)
        return view
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Constants.RefreshAlarms, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
        action()
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: Constants.RefreshAlarms, object: nil)
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        let sv = UIStackView(arrangedSubviews: [addButtonView, editButtonView, deleteButtonView])
        sv.axis = .horizontal
        sv.spacing = 10.0
        sv.alignment = .leading
        sv.distribution = .fillEqually
        view.addSubview(sv)
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
        }
        sv.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        for btn in [addButtonView, editButtonView, deleteButtonView] {
            btn.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.bottom.equalTo(sv.snp.top).offset(-20)
        }
    }
    
    private func action() {
        addButtonView.button.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            if self.addButtonView.button.isSelected {
                PopupVC.showAlert(vc: self, title: "알림", message: "먼저 아이템을 선택하세요")
                return
            }
            
            let customInitData = AddInitData(editMode: false, data: nil)
            let dataProvider = BaseVCInitDataProvider(customInitData: customInitData)
            let vc = AddViewController(initDataProvider: dataProvider)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
        
        editButtonView.button.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            if self.editButtonView.button.isSelected {
                PopupVC.showAlert(vc: self, title: "알림", message: "먼저 아이템을 선택하세요")
                return
            }
            
            let customInitData = AddInitData(editMode: true, data: SaveDataManager.shared.getSelectedData())
            let dataProvider = BaseVCInitDataProvider(customInitData: customInitData)
            let vc = AddViewController(initDataProvider: dataProvider)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }.disposed(by: disposeBag)
        
        deleteButtonView.button.rx.tap.bind { [weak self] in
            guard let self = self else {
                return
            }
            if let data = datas.first(where: { $0.selected == true }) {
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
        
        settingButtonView.button.rx.tap.bind { _ in
            
        }.disposed(by: disposeBag)
    }
    
    @objc func refresh() {
        datas = SaveDataManager.shared.getList()
        tableView.reloadData()
        
        // Edit, Delete 버튼 활성화 체크
        if datas.first(where: { $0.selected == true }) != nil {
            editButtonView.button.isSelected = false
            deleteButtonView.button.isSelected = false
        } else {
            editButtonView.button.isSelected = true
            deleteButtonView.button.isSelected = true
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
        let index = indexPath.row
        let data = datas[index]
        if let cell: AlarmItemCell = tableView.dequeueReusableCell(withIdentifier: "AlarmItemCell") as? AlarmItemCell {
            var type: AlarmItemType = .none
            if index == 0, index == datas.count - 1 {
                type = .topBottom
            } else if index == 0 {
                type = .top
            } else if index == datas.count - 1 {
                type = .bottom
            }
            cell.setData(data: data, index: indexPath.row, type: type)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datas[indexPath.row]
        if data.selected == false {
            SaveDataManager.shared.update(selectId: data.id)
            refresh()
        }
    }
}
