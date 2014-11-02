//
//  TodayViewController.swift
//  FrameworkToday
//
//  Created by Antti Mattila on 1.11.2014.
//  Copyright (c) 2014 Alupark. All rights reserved.
//

import UIKit
import NotificationCenter
import NoteDashCommon

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var textLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "userDefaultsDidChange:",
            name: NSUserDefaultsDidChangeNotification,
            object: nil)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 42.0, 0, 8.0)
    }
    
    func userDefaultsDidChange(notification: NSNotification) {
        updateText()
    }
    
    func updateText() {
        self.textLabel.text = DataStore.readDefaults()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        updateText()
        completionHandler(NCUpdateResult.NewData)
    }
    
}
