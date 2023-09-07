//
//  AddViewController+extension.swift
//  AlarmService
//
//  Created by 김형진 on 2023/09/01.
//

import UIKit

extension AddViewController {
    func requestNotificationAuthorization() {
        let options = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("reuqest error! \(error.localizedDescription)")
                return
            }
            
            // 알림이 허용되지 않았을 경우
            if success == false {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    // 앱 설정으로 이동
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func sendNotification(date: Date, title: String, desc: String, cbComplete: (() -> Void)? = nil) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MMM dd일 a hh시 mm분"
        let message = "\(formatter.string(from: date))에 알려드릴게요"
        let request = getSendNotificationRequest(date: date, title: title, desc: desc)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("send error! \(error.localizedDescription)")
                return
            }
            
            if self.viewModel.editMode {
                if let data = self.viewModel.editData.value {
                    PopupVC.showAlert(vc: self, title: "알림", message: "\(data.desc)를 \(desc)로 변경했습니다.\n\(message)") {
                        cbComplete?()
                    }
                }
            } else {
                PopupVC.showAlert(vc: self, title: "알림", message: "'\(desc)'를 스케줄에 추가했습니다.\n\(message)")
            }
            SaveDataManager.shared.save(id: request.identifier, date: date, desc: desc)
        }
    }
    
    private func getSendNotificationRequest(date: Date, title: String, desc: String) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = desc
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alert.wav")) // UNNotificationSound.default
        
        var identifier = "id_\(NSDate().timeIntervalSince1970)"
        
        if viewModel.editMode {
            if let data = viewModel.editData.value {
                identifier = data.id
                // 이전 알림 삭제
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [data.id])
            }
        }
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
        
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
}
