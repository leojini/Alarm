//
//  AppDelegate.swift
//  AlarmService
//
//  Created by 김형진 on 2023/08/18.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        UNUserNotificationCenter.current().delegate = self
                
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

        application.registerForRemoteNotifications()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("id aaa : \(response.notification.request.identifier)")
        completionHandler()
        NotificationCenter.default.post(name: Constants.RefreshAlarms, object: nil, userInfo: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("id bbb : \(notification.request.identifier)")
        completionHandler([.alert, .badge, .sound])
        NotificationCenter.default.post(name: Constants.RefreshAlarms, object: nil, userInfo: nil)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcm token: \(fcmToken)")
    }
}
