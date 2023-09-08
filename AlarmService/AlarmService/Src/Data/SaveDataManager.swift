//
//  SaveData.swift
//  AlarmService
//
//  Created by 김형진 on 2023/08/25.
//

import Foundation

final class SaveCommon {
    static let SaveDatas: String = "SaveDatas"
}

struct SaveData: Codable {
    let id: String
    let desc: String
    let dateStr: String
    var option: Bool = false
    
    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat
        if let date = formatter.date(from: dateStr) {
            return date
        }
        return nil
    }
    var expired: Bool {
        if date?.compare(Date()) == .orderedAscending {
            return true
        }
        return false
    }
}

class SaveDataManager {
    static let shared = SaveDataManager()
    
    private init() {}
    
    func start() {
        
    }
    
    func save(id: String, date: Date, desc: String, option: Bool = false) {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat
        let dateStr = formatter.string(from: date)
        
        let data = SaveData(id: id, desc: desc, dateStr: dateStr, option: option)
        if var saveArray = UserDefaultsManager.saveDatas {
            saveArray.append(data)
            UserDefaultsManager.saveDatas = saveArray
        } else {
            var saveArray: [SaveData] = []
            saveArray.append(data)
            UserDefaultsManager.saveDatas = saveArray
        }
    }
    
    func deleteExpired() {
        // 시간이 지난 데이터를 삭제한다.
        if var saveArray = UserDefaultsManager.saveDatas {
            for (index, item) in saveArray.enumerated().reversed() {
                if item.expired {
                    saveArray.remove(at: index)
                }
            }
            UserDefaultsManager.saveDatas = saveArray
        }
    }
    
    func delete(id: String) -> Bool {
        if var saveArray = UserDefaultsManager.saveDatas, let index = saveArray.firstIndex(where: { obj in obj.id == id }) {
            saveArray.remove(at: index)
            UserDefaultsManager.saveDatas = saveArray
            return true
        }
        return false
    }
    
    func getList() -> [SaveData] {
        if var saveArray = UserDefaultsManager.saveDatas {
            saveArray.sort { d1, d2 in
                d1.id > d2.id
            }
            return saveArray
        }
        return []
    }
    
    func update(datas: [SaveData]) {
        UserDefaultsManager.saveDatas = datas
    }
    
    func update(id: String, data: SaveData) {
        if var saveArray = UserDefaultsManager.saveDatas, let index = saveArray.firstIndex(where: { obj in obj.id == id }) {
            saveArray.remove(at: index)
            saveArray.insert(data, at: index)
            UserDefaultsManager.saveDatas = saveArray
        }
    }
    
    func getSelectedData() -> SaveData? {
        if let saveArray = UserDefaultsManager.saveDatas, let item = saveArray.first(where: { $0.option == true }) {
            return item
        }
        return nil
    }
}
