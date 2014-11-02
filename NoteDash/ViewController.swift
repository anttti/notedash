//
//  ViewController.swift
//  NoteDash
//
//  Created by Antti Mattila on 1.11.2014.
//  Copyright (c) 2014 Alupark. All rights reserved.
//

import UIKit
import NoteDashCommon

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dismissKeyboardButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = DataStore.readDefaults()
        textView.alwaysBounceVertical = true
        textView.delegate = self
        textView.inputAccessoryView = KeyboardAccessoryView()
        textView.becomeFirstResponder()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidMove:", name: "APKeyboardMoved", object: nil)
    }
    
    @IBAction func onDismissKeyboardPressed(sender: AnyObject) {
        textView.resignFirstResponder()
        dismissKeyboardButton.enabled = false
    }
    
    func keyboardDidMove(notification: NSNotification) {
        let view = notification.object as UIView
        let rect = view.convertRect(view.bounds, toView: self.view)
        
        let bottom = self.view.bounds.size.height - rect.origin.y
        self.bottomConstraint.constant = bottom + 8;
        
        self.view.layoutIfNeeded()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        dismissKeyboardButton.enabled = true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        DataStore.writeDefaults(self.textView.text + text)
        return true
    }
}

