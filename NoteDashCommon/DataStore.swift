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
            defaults.setObject(str, forKey: "noteString")
            defaults.synchronize()
        }
    }
    
    public class func readDefaults() -> String! {
        let defs = NSUserDefaults(suiteName: "group.alupark.NoteDash")
        if let defaults = defs {
            if let str = defaults.objectForKey("noteString") as String? {
                return str
            }
        }
        return ""
    }
}