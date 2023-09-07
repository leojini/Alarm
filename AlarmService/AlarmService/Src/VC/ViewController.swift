//
//  ViewController.swift
//  AlarmService
//
//  Created by 김형진 on 2023/08/18.
//

import UIKit

class ViewController: UIViewController {

    private var datas: [SaveData] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Constants.RefreshAlarms, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(AlarmItemCell.self, forCellReuseIdentifier: "AlarmItemCell")
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: Constants.RefreshAlarms, object: nil)
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

    @IBAction func onAdd(_ sender: Any) {
        let customInitData = AddInitData(editMode: false, data: nil)
        let dataProvider = BaseVCInitDataProvider(customInitData: customInitData)
        let vc = AddViewController(initDataProvider: dataProvider)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func onEdit(_ sender: Any) {
        let customInitData = AddInitData(editMode: true, data: SaveDataManager.shared.getSelectedData())
        let dataProvider = BaseVCInitDataProvider(customInitData: customInitData)
        let vc = AddViewController(initDataProvider: dataProvider)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func onDelete(_ sender: Any) {
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
