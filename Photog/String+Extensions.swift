//
//  String+Extensions.swift
//  Photog
//
//  Created by Lin Wen Chun on 2015/6/17.
//  Copyright (c) 2015年 Lin Wen Chun. All rights reserved.
//

import Foundation

extension String {
    func isEmailAddress() -> Bool {
        var predicate = self.predicateForEmail()
        return predicate.evaluateWithObject(self)
    }
    
    func predicateForEmail() -> NSPredicate {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return NSPredicate(format: "SELF MATCHES %@", regularExpression)
    }
}