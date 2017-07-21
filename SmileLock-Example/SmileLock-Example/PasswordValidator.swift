//
//  PasswordValidator.swift
//  SmileLock-Example
//
//  Created by 廖垚雨 on 2/1/17.
//  Copyright © 2017 raniys. All rights reserved.
//

import UIKit
import SmileLock

class PasswordModel {
    class func match(_ password: String) -> PasswordModel? {
        guard password == "123456" else { return nil }
        return PasswordModel()
    }
}

class PasswordValidator: PasswordUIValidation<PasswordModel> {
    init(in containerView: UIView, digit: Int) {
        super.init(in: containerView, digit: digit)
        self.validation = { password in
            PasswordModel.match(password)
        }
    }
    
    //handle Touch ID
    override func touchAuthenticationComplete(_ passwordContainerView: PasswordContainerView, success: Bool, error: Error?) {
        if success {
            let dummyModel = PasswordModel()
            self.success?(dummyModel)
        } else {
            passwordContainerView.clearInput()
        }
    }
}

