//
//  TestClass.swift
//  FrameworkTest
//
//  Created by Antti Mattila on 1.11.2014.
//  Copyright (c) 2014 Alupark. All rights reserved.
//

import UIKit

public class DataStore {
    public class func writeDefaults(str: String) {
        let defs = NSUserDefaults(suiteName: "group.alupark.NoteDash")
        if let defaults = defs {
            if str == placeholderText() || str == "" {
                defaults.setObject(widgetPlaceholderText(), forKey: userDefaultsKey())
            } else {
                defaults.setObject(str, forKey: userDefaultsKey())
            }
            defaults.synchronize()
        }
    }
    
    public class func readDefaults() -> String! {
        let defs = NSUserDefaults(suiteName: "group.alupark.NoteDash")
        if let defaults = defs {
            if let str = defaults.objectForKey(userDefaultsKey()) as String? {
                if str != "" {
                    return str
                }
            }
        }
        return placeholderText()
    }
    
    public class func placeholderText() -> String! {
        return "Enable the NoteDash widget in your Notification Center and you'll see anything you type here appear in the widget!"
    }
    
    private class func userDefaultsKey() -> String! {
        return "noteString"
    }
    
    private class func widgetPlaceholderText() -> String! {
        return "Tap here to edit this message. You can write whatever you want and have a quick access to it anywhere, anytime!"
    }
}