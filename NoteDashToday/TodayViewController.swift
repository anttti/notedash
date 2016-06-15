//
//  TodayViewController.swift
//  NoteDashToday
//
//  Created by Antti Mattila on 1.11.2014.
//  Copyright (c) 2014 Alupark. All rights reserved.
//

import UIKit
import NotificationCenter
import NoteDashCommon

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        NotificationCenter.default().addObserver(self,
            selector: #selector(TodayViewController.userDefaultsDidChange(_:)),
            name: UserDefaults.didChangeNotification,
            object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateText()
        tapRecognizer.addTarget(self, action: #selector(TodayViewController.onTap))
    }
    
    func userDefaultsDidChange(_ notification: Notification) {
        updateText()
    }
    
    func updateText() {
        self.textLabel.text = DataStore.readDefaultsForTarget(MessageTarget.widget)
    }
    
    func onTap() {
        let url = URL(string: "alupark.notedash://")!
        if let content = self.extensionContext {
            content.open(url, completionHandler: nil)
        }
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 42.0, 0, 8.0)
    }
    
    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        updateText()
        completionHandler(NCUpdateResult.newData)
    }
    
}
