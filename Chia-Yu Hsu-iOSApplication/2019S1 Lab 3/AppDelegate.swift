//
//  AppDelegate.swift
//  2019S1 Lab 3
//
//  Created by Michael Wybrow on 15/3/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{

    var window: UIWindow?
    var databaseController: DatabaseProtocol?
    var locationManager = CLLocationManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //setting navigation bar color
        let uiNavbarProxy = UINavigationBar.appearance()
        uiNavbarProxy.barTintColor = UIColor(red: 1, green: 0.66, blue: 0.67, alpha: 1)
        uiNavbarProxy.tintColor = UIColor.white
        uiNavbarProxy.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        databaseController = CoreDataController()
        
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //get authorization
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error{
            print("\(error)")
            }}
        return true
    }
    
    //show notification when enter
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        hadleEvent(for: region, eventType: "entered into")
    }
    //show notification when exit
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        hadleEvent(for: region, eventType: "exited into")
    }
    
    func hadleEvent(for region: CLRegion!, eventType: String){
        if UIApplication.shared.applicationState == .active{
            return
        }else{
            let body  = "You have \(eventType) \(region.identifier)!"
            let notificationContent = UNMutableNotificationContent()
            notificationContent.body = body
            notificationContent.sound = UNNotificationSound.default
            notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "location_change", content: notificationContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request){ error in
                if let error = error{
                    print("\(error)")
                }
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //housekeeping by clearing out all existing notifications
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

