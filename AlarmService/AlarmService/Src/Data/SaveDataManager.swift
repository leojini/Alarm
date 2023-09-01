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
}

class SaveDataManager {
    static let shared = SaveDataManager()
    
    private init() {}
    
    func save(id: String, date: Date, desc: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.DateFormat
        let dateStr = formatter.string(from: date)
        
        print("id: \(id)")
        
        let data = SaveData(id: id, desc: desc, dateStr: dateStr)
        if var saveArray = UserDefaultsManager.saveDatas {
            saveArray.append(data)
            UserDefaultsManager.saveDatas = saveArray
        } else {
            var saveArray: [SaveData] = []
            saveArray.append(data)
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
