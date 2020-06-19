//
//  SignUpViewController.swift
//  LoginTemplate
//
//  Created by Steve Jones on 17/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var fieldBackground: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordField.delegate = self
        passwordConfirmationField.delegate = self
        
        //set field background
        fieldBackground.backgroundColor = UIColor(named: "MidnightBlue")
        fieldBackground.alpha = 0.9
        fieldBackground.layer.cornerRadius = 8.0
        fieldBackground.layer.borderWidth = 5
        fieldBackground.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
        
        signUpButton.layer.cornerRadius = 25.0
        signUpButton.layer.borderWidth = 5.0
        signUpButton.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
        
        //close keyboard on tap
        let tap = UITapGestureRecognizer(target:self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
          
        
    }
    

    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        print("sign up button pressed!")
    //Add sign up firebase code here
    }
    

   
    
    
 
}

//MARK:- extension for textfield delegate

extension SignUpViewController: UITextFieldDelegate {
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == self.emailTextField {
                self.passwordField.becomeFirstResponder()
            }
            if textField == self.passwordField {
                self.passwordConfirmationField.becomeFirstResponder()
            }
            if textField == self.passwordConfirmationField {
                self.view.endEditing(true)
        }
            return true
    }
    
    
    
}
