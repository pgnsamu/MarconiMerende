//
//  AppDelegate.swift
//  bar2
//
//  Created by Samuele Pagnotta on 15/03/22.
//


import UIKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      FirebaseApp.configure()


    return true
  }
}
