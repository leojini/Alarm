//
//  SettingViewController.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/19.
//

import UIKit
import RxSwift

struct SettingInitData {
    
}

class SettingViewController: BaseVC<SettingInitData> {
    
    private let disposeBag = DisposeBag()
    let viewModel: SettingVM
    
    private let sv: UIScrollView = {
        let sv = UIScrollView()
        sv.scrollIndicatorInsets = UIEdgeInsets.zero
        return sv
    }()
    
    required init<T>(initDataProvider: T) where SettingInitData == T.CustomInitData, T : BaseVCInitDataProviderType {
        self.viewModel = SettingVM(initData: initDataProvider.customInitData)
        super.init(initDataProvider: initDataProvider)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
