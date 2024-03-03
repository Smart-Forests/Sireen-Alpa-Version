//
//  AppDelegate.swift
//  PawsAndFound
//
//  Created by Jose Baez on 10/30/23.
//

import UIKit
import UserNotifications
import ParseSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        ParseSwift.initialize(applicationId: "9mnVuaIWtTVH83CU5rED4zappVxgFPrZHuZbutzw",
                              clientKey: "zEyBdMk1e5f5XxKs50745OYdqneKeZ2voTCLIeQt",
                              serverURL: URL(string: "https://parseapi.back4app.com")!)
        
        
       //Notifications for the PawsAndFound App
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
            if granted {
                print("Allowed!")
            } else {
                print("Not allowed!")
            }
        })
        
        return true
    }

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
    
    func scheduleNotification (){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Help Find Pets!"
        content.body = "More people have lost their pets help find them!"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: true)

       let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
       center.add(request)
    }
}
