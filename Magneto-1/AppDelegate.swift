//
//  AppDelegate.swift
//  Magneto-1
//
//  Created by Juri Kiin on 2/4/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var vc = ViewController()
    let defaults = UserDefaults.standard
    let wordKey = "labelTextKey"
    let xKey = "posKeyX"
    let yKey = "posYKey"
    var wordArr: [String] = []
    var posX: [Float] = []
    var posY: [Float] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch
        vc = window?.rootViewController as! ViewController
        
        //Load up any labels we previously had
        wordArr = defaults.object(forKey: wordKey) as? [String] ?? [String]()
        posX = defaults.object(forKey: xKey) as? [Float] ?? [Float]()
        posY = defaults.object(forKey: yKey) as? [Float] ?? [Float]()
        
        //Loop through each one and create a new Label with it.
        if wordArr.count > 0{
            for i in 0 ..< wordArr.count {
                let newLabel = UILabel()
                //Set the label properties
                newLabel.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                newLabel.text = "   \(wordArr[i])   "
                newLabel.font = newLabel.font.withSize(CGFloat(vc.currentFontSize))
                newLabel.layer.borderColor = UIColor.black.cgColor
                newLabel.layer.borderWidth = 1.0
                newLabel.sizeToFit()
                vc.wordArray.append(newLabel)
                vc.view.addSubview(newLabel)
                //Make it interactable
                newLabel.isUserInteractionEnabled = true
                //Add a pan gesture to the label
                vc.addPanGesture(label: newLabel)
                //Get the position of the longPress to animate from there.
                let x = CGFloat(posX[i])
                let y = CGFloat(posY[i])
                newLabel.center = CGPoint(x: x, y: y)
            }
        }

        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:
        
        let labelArray = vc.returnWordArray()
        var wordArray: [String] = []
        var xArray: [Float] = []
        var yArray: [Float] = []
        for word in labelArray {
            wordArray.append(word.text!)
            xArray.append(Float(word.center.x))
            yArray.append(Float(word.center.y))
        }
        defaults.set(wordArray, forKey: wordKey)
        defaults.set(xArray, forKey: xKey)
        defaults.set(yArray, forKey: yKey)
    }


}

