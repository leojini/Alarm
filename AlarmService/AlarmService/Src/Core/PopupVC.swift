//
//  PopupVC.swift
//  AlarmService
//
//  Created by 김형진 on 2023/08/24.
//

import UIKit

class PopupVC: UIViewController {
    static func showAlert(vc: UIViewController, title: String, message: String, okHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                okHandler?()
            }))
            vc.modalPresentationStyle = .fullScreen
            vc.present(controller, animated: true)
        }
    }
    
    static func showAlert(vc: UIViewController, title: String, message: String, okHandler: (() -> Void)? = nil, cancelHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                cancelHandler?()
            }))
            controller.addAction(UIAlertAction(title: "Done", style: .default, handler: { action in
                okHandler?()
            }))
            vc.modalPresentationStyle = .fullScreen
            vc.present(controller, animated: true)
        }
    }
}
