//
//  KeyboardController.swift
//  SmileLock-Example
//
//  Created by raniys on 2/1/17.
//  Copyright © 2017 raniys. All rights reserved.
//

import UIKit
import SmileLock

class KeyboardController: UIViewController {
    
    @IBOutlet weak var keyboardContainer: UIView!
    
    //MARK: Property
    var passwordUIValidator: PasswordValidator!
    let kPasswordDigit = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordUIValidator = PasswordValidator(in: keyboardContainer, digit: kPasswordDigit)
        passwordUIValidator.success = { [weak self] _ in
            print("*️⃣ success!")
            self?.dismiss(animated: true, completion: nil)
        }
        
        passwordUIValidator.failure = { _ in
            //do not forget add [weak self] if the view controller become nil at some point during its lifetime
            print("*️⃣ failure!")
        }
    }
}
