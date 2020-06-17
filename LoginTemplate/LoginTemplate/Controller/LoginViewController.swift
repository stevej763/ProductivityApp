//
//  LoginViewController.swift
//  LoginTemplate
//
//  Created by Steve Jones on 17/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var credentialBackground: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmailField.delegate = self
        userPasswordField.delegate = self

        credentialBackground.backgroundColor = UIColor(named: "MidnightBlue")
        credentialBackground.alpha = 0.9
        credentialBackground.layer.cornerRadius = 8.0
        credentialBackground.layer.borderWidth = 5
        credentialBackground.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
        
        loginButton.layer.cornerRadius = 25.0
        loginButton.layer.borderWidth = 5.0
        loginButton.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
        
        //close keyboard on tap
        let tap = UITapGestureRecognizer(target:self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    

    @IBAction func loginButtonPressed(_ sender: Any) {
        print("Login button was pressed")
        
        //do firebase authentication stuff here
        
    }
   
    
    
    
}

extension LoginViewController: UITextFieldDelegate {
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == self.userEmailField {
                self.userPasswordField.becomeFirstResponder()
            }
            if textField == self.userPasswordField {
                self.view.endEditing(true)
            }
            return true
    }
    
    
}
