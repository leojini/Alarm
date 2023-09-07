//
//  NibLoadable.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/01.
//

import UIKit

protocol NibLoadable {
    static func nibNameAndBundle() -> (String, Bundle)
}

class NibLoadableUIViewController<InitData>: UIViewController, NibLoadable {
    let initData: InitData

    required init(initData: InitData) {

        self.initData = initData
        let (nibName, bundle) = type(of: self).nibNameAndBundle()
        super.init(nibName: nibName, bundle: bundle)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func customInit() {}
}

extension NibLoadable where Self: UIViewController {

    static func nibNameAndBundle() -> (String, Bundle) {
        let bundle = Bundle(for: Self.self)
        let nibName = String(describing: self)
        return (nibName, bundle)
    }

    static func instanceFromNib() -> Self {
        return privateInstanceFromNib(self)
    }

    private static func privateInstanceFromNib<T: UIViewController>(_: T.Type) -> T {
        let nibName = String(describing: self)
        return T(nibName: nibName, bundle: .main)
    }
}
