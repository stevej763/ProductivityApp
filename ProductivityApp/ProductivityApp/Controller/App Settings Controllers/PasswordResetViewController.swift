//
//  PasswordResetViewController.swift
//  ProductivityApp
//
//  Created by Steve Jones on 28/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase

class PasswordResetViewController: UIViewController {
    
    let auth = Auth.auth()

    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var newPassowrdConfirmFIield: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var currentPasswordErrorLabel: UILabel!
    
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func passowrdUpdateButtonPressed(_ sender: Any) {
        errorLabel.text = nil
        currentPasswordErrorLabel.text = nil
        if currentPasswordField.text != "" && newPasswordField.text != "" && newPassowrdConfirmFIield.text != "" {
            checkCurrentPassword()
        } else {
            errorLabel.textColor = .red
            errorLabel.text = "Please fill in all fields."
        }
    }
    
    
    func checkCurrentPassword(){
        guard let user = auth.currentUser else {return}
        
        auth.signIn(withEmail: user.email! , password: currentPasswordField.text!) { (authResult, error) in
            if error != nil {
                self.currentPasswordErrorLabel.textColor = .red
                self.currentPasswordErrorLabel.text = "Incorrect Password."
                return
            } else {
                self.updatePassword()
            }
        }
    
        
        
    }
    
    
    
    func updatePassword(){
        if newPasswordField.text == newPassowrdConfirmFIield.text {
            
        Auth.auth().currentUser?.updatePassword(to: newPasswordField.text!) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                switch error!.localizedDescription {
                case "The password must be 6 characters long or more.":
                    self.errorLabel.textColor = .red
                    self.errorLabel.text = "The new password must be at least 6 charaters long."
                    
                default:
                    self.errorLabel.text = "There was an error updating your password, please try again."
                }
            } else {
                print("Passowrd Updated")
                self.dismiss(animated: true)
            }
        }
        
        } else {
            errorLabel.textColor = .red
            errorLabel.text = "Password confirmation does not match."
        }
    }

}
