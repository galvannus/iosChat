//
//  AppDelegate.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 03/10/23.
//

import FBSDKCoreKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainController()
        window?.makeKeyAndVisible()
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        /*var handled: Bool

        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        

        // Handle other custom URL types.

        // If not handled by this app, return false.
        return false
         */
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        // Register for GetURL events.
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                print("Google user disconnected.")
            } else {
                // Show the app's signed-in state.
                print("Google user connected.")
            }
        }
    }
    
}
