//
//  TestClass.swift
//  NoteDashCommon
//
//  Created by Antti Mattila on 1.11.2014.
//  Copyright (c) 2014 Alupark. All rights reserved.
//

import UIKit

public enum MessageTarget {
    case Widget
    case TextView
}

public class DataStore {
    
    public class func writeDefaults(str: String) {
        let defs = NSUserDefaults(suiteName: suiteName())
        
        if let defaults = defs {
            if str == placeholderTextForTarget(MessageTarget.TextView) || str == "" {
                defaults.setObject("", forKey: userDefaultsKey())
            } else {
                defaults.setObject(str, forKey: userDefaultsKey())
            }
            defaults.synchronize()
        }
    }
    
    public class func readDefaultsForTarget(target: MessageTarget) -> String! {
        let defs = NSUserDefaults(suiteName: suiteName())
        
        if let str = defs?.objectForKey(userDefaultsKey()) as String? {
            if str != "" {
                return str
            }
        }

        return placeholderTextForTarget(target)
    }
    
    public class func placeholderTextForTarget(target: MessageTarget) -> String! {
        switch target {
            case .Widget:
                return "Tap here to edit this message. You can write whatever you want and have a quick access to it anywhere, anytime!"
            case .TextView:
                return "Enable the NoteDash widget in your Notification Center and you'll see anything you type here appear in the widget!"
            default:
                return ""
        }
    }
    
    // These are funcs until Swift supports static class lets
    
    private class func suiteName() -> String! {
        return "group.alupark.NoteDash"
    }
    
    private class func userDefaultsKey() -> String! {
        return "noteString"
    }
}