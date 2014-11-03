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
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        setupLogoView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardDidMove:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidMove:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        let item = UIBarButtonItem(image: UIImage(named: "keyboard-down"), landscapeImagePhone: UIImage(named: "keyboard-down"), style: UIBarButtonItemStyle.Plain, target: self, action: "doneBarButtonItemTapped")
        item.tintColor = UIColor.whiteColor()
        navigationItem.setRightBarButtonItem(item, animated: true)
        
        if textView.text == DataStore.placeholderTextForTarget(MessageTarget.TextView) {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = DataStore.placeholderTextForTarget(MessageTarget.TextView)
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        DataStore.writeDefaults(textView.text)
    }
    
    // MARK: Custom handlers
    
    func keyboardDidMove(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        // Adjust the UITextView's bottom constraint to accommodate the keyboard
        bottomConstraint.constant -= originDelta
        
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    func doneBarButtonItemTapped() {
        textView.resignFirstResponder()
        navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    
    // MARK: UI setup
    
    func setupTextView() {
        textView.text = DataStore.readDefaultsForTarget(MessageTarget.TextView)
        
        if textView.text == DataStore.placeholderTextForTarget(MessageTarget.TextView) {
            textView.textColor = UIColor.lightGrayColor()
        } else {
            textView.becomeFirstResponder()
        }
        
        textView.alwaysBounceVertical = true
        textView.delegate = self
        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setupLogoView() {
        let logoImage = UIImage(named: "notedash-logo")
        let logoImageView = UIImageView(image: logoImage)
        navigationItem.titleView = logoImageView
    }
}

