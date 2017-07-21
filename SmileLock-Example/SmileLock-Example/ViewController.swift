//
//  ViewController.swift
//  SmileLock-Example
//
//  Created by raniys on 2/1/17.
//  Copyright © 2017 raniys. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var showBlurKeyboard = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func setToShowBlurVersion(_ sender: UISwitch) {
        if sender.isOn {
            showBlurKeyboard = true
        } else {
            showBlurKeyboard = false
        }
    }
    
    @IBAction func showKeyboardTapped(_ sender: UIButton) {
        let keyboardID = showBlurKeyboard ? "BlurKeyboardController" : "KeyboardController"
        present(keyboardID)
    }
    
    func present(_ id: String) {
        guard let storyboard = storyboard else { return }

        let keyboardVC = storyboard.instantiateViewController(withIdentifier: id)
        keyboardVC.modalTransitionStyle = .crossDissolve
        keyboardVC.modalPresentationStyle = .overCurrentContext
        present(keyboardVC, animated: true, completion: nil)
    }
    
}

