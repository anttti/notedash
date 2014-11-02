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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = DataStore.readDefaults()
        textView.alwaysBounceVertical = true
        textView.delegate = self
        textView.becomeFirstResponder()
        
        self.automaticallyAdjustsScrollViewInsets = false
  
        let logoImage = UIImage(named: "notedash-logo")
        let logoImageView = UIImageView(image: logoImage)
        navigationItem.titleView = logoImageView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        keyboardDidMove(notification)
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        keyboardDidMove(notification)
    }
    
    func keyboardDidMove(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        bottomConstraint.constant -= originDelta
        
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        let item = UIBarButtonItem(image: UIImage(named: "keyboard-down"), landscapeImagePhone: UIImage(named: "keyboard-down"), style: UIBarButtonItemStyle.Plain, target: self, action: "doneBarButtonItemTapped")
        item.tintColor = UIColor.whiteColor()
        navigationItem.setRightBarButtonItem(item, animated: true)
    }
    
    func doneBarButtonItemTapped() {
        textView.resignFirstResponder()
        navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        DataStore.writeDefaults(self.textView.text + text)
        return true
    }
}

