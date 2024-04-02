//
//  AppDelegate.swift
//  WaxpeerRT
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import UIKit
import AppNetwork

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var manager: WaxpeerSocketManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        manager = WaxpeerSocketManager(env: .waxpeer)
        manager?.delegate = self
        
        if let manager {
            manager.connect()
        } else {
            print("Something went wrong")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

extension AppDelegate: WaxpeerSocketDelegate {
    func waxpeerSocketDidConnect(_ socket: AppNetwork.WaxpeerSocketManager) async {
        print("Connected")
    }
    
    func waxpeerSocketDidDisconnect(_ socket: AppNetwork.WaxpeerSocketManager) async {
        print("Disconnected")
    }
    
    func waxpeerSocket(_ socket: AppNetwork.WaxpeerSocketManager, didReceiveGameItem item: GameItem, event: WaxpeerGameItemEvent) async {
        print("GAME: \(item.game), event: \(event.rawValue)")
    }
}
