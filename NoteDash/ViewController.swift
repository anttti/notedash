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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default()
        notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardDidMove(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(ViewController.keyboardDidMove(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        let notificationCenter = NotificationCenter.default()
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let item = UIBarButtonItem(image: UIImage(named: "keyboard-down"), landscapeImagePhone: UIImage(named: "keyboard-down"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewController.doneBarButtonItemTapped))
        item.tintColor = UIColor.white()
        navigationItem.setRightBarButton(item, animated: true)
        
        if textView.text == DataStore.placeholderTextForTarget(MessageTarget.textView) {
            textView.text = ""
            textView.textColor = UIColor.black()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = DataStore.placeholderTextForTarget(MessageTarget.textView)
            textView.textColor = UIColor.lightGray()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        DataStore.writeDefaults(textView.text)
    }
    
    // MARK: Custom handlers
    
    func keyboardDidMove(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo!
        
        let animationDuration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue()
        
        let keyboardViewBeginFrame = view.convert(keyboardScreenBeginFrame, from: view.window)
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        // Adjust the UITextView's bottom constraint to accommodate the keyboard
        bottomConstraint.constant -= originDelta
        
        view.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .beginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    func doneBarButtonItemTapped() {
        textView.resignFirstResponder()
        navigationItem.setRightBarButton(nil, animated: true)
    }
    
    // MARK: UI setup
    
    func setupTextView() {
        textView.text = DataStore.readDefaultsForTarget(MessageTarget.textView)
        
        if textView.text == DataStore.placeholderTextForTarget(MessageTarget.textView) {
            textView.textColor = UIColor.lightGray()
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

