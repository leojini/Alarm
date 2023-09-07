//
//  AddVM.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/01.
//

import Foundation
import RxSwift
import RxRelay

class AddVM: NSObject {
    var editMode: Bool = false
    let editData = BehaviorRelay<SaveData?>.init(value: nil)
    
    required init(initData: AddInitData) {
        self.editMode = initData.editMode
        self.editData.accept(initData.data)
    }
}
