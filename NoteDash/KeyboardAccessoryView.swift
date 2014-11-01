//
//  KeyboardAccessoryView.swift
//  NoteDash
//
//  Created by Antti Mattila on 1.11.2014.
//  Copyright (c) 2014 Alupark. All rights reserved.
//

import UIKit

class KeyboardAccessoryView: UIView {
    override func willMoveToSuperview(newSuperview: UIView?) {
        if let superview = self.superview {
            superview.removeObserver(self, forKeyPath: "center")
        }
        
        if let newSuper = newSuperview {
            newSuper.addObserver(self, forKeyPath: "center", options: nil, context: nil)
        }
        
        super.willMoveToSuperview(newSuperview)
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (object as? NSObject == self.superview && keyPath == "center") {
            NSNotificationCenter.defaultCenter().postNotificationName("APKeyboardMoved", object: self)
        }
    }
}