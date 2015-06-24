//
//  UIViewController+Extensions.swift
//  Photog
//
//  Created by Lin Wen Chun on 2015/6/17.
//  Copyright (c) 2015年 Lin Wen Chun. All rights reserved.
//

import Foundation

extension UIViewController {
    func showAlert(message: String) {
        self.showAlert("Uh Oh!", message: message)
    }
    
    func showAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }
}