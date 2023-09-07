//
//  BaseVC.swift
//  AlarmService
//
//  Created by 김형진 on 2023/08/18.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol BaseVCInitDataProviderType {
    associatedtype CustomInitData
    
    var customInitData: CustomInitData { get }
}

struct BaseVCInitDataProvider<T>: BaseVCInitDataProviderType {
    var customInitData: CustomInitData
    
    typealias CustomInitData = T
}

class BaseVC<CustomInitData>: UIViewController {
    
    required init<T>(initDataProvider: T) where T: BaseVCInitDataProviderType, T.CustomInitData == CustomInitData {
        if let nibLoaddable = Self.self as? NibLoadable.Type {
            let data = nibLoaddable.nibNameAndBundle()
            super.init(nibName: data.0, bundle: data.1)
        } else {
            super.init(nibName: nil, bundle: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    }
}
