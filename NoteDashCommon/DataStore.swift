//
//  TestClass.swift
//  NoteDashCommon
//
//  Created by Antti Mattila on 1.11.2014.
//  Copyright (c) 2014 Alupark. All rights reserved.
//

import UIKit

public enum MessageTarget {
    case widget
    case textView
}

public class DataStore {
    
    public class func writeDefaults(_ str: String) {
        let defs = UserDefaults(suiteName: suiteName())
        
        if let defaults = defs {
            if str == placeholderTextForTarget(MessageTarget.textView) || str == "" {
                defaults.set("", forKey: userDefaultsKey())
            } else {
                defaults.set(str, forKey: userDefaultsKey())
            }
            defaults.synchronize()
        }
    }
    
    public class func readDefaultsForTarget(_ target: MessageTarget) -> String! {
        let defs = UserDefaults(suiteName: suiteName())
        
        if let str = defs?.object(forKey: userDefaultsKey()) as! String? {
            if str != "" {
                return str
            }
        }

        return placeholderTextForTarget(target)
    }
    
    public class func placeholderTextForTarget(_ target: MessageTarget) -> String! {
        switch target {
            case .widget:
                return "Tap here to edit this message. You can write whatever you want and have a quick access to it anywhere, anytime!"
            case .textView:
                return "Enable the NoteDash widget in your Notification Center and you'll see anything you type here appear in the widget!"
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
