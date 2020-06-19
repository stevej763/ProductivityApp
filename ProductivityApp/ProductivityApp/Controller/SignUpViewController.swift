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
          
        
        //uncomment for firebase credential check
//         if Auth.auth().currentUser != nil {
//                  self.performSegue(withIdentifier: "LoginToHome", sender: nil)
//               }
//
//
//               //debug logout user
//               if Auth.auth().currentUser?.uid != nil{
//                   useridcheck.text = Auth.auth().currentUser!.uid
//               }
        
        
        
    }
    

    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        print("sign up button pressed!")
        //Add sign up firebase code here
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Email Blank", message: "Please enter a valid email address.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if passwordField.text == "" {
            let alertController = UIAlertController(title: "Password Invalid", message: "Please enter a password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if passwordField.text != passwordConfirmationField.text {
            let alertController = UIAlertController(title: "Passwords do not match", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            //firebase authentication uncomment when firebase pod loaded
            //                Auth.auth().createUser(withEmail: SignUpEmail.text!, password: SignUpPassword.text!){ (authResult, error) in
            //                    if error == nil {
            //                        print("Account Created!")
            //                        let db = Firestore.firestore()
            //                        let accountCreationDate = Date()
            //                        let newUserID = authResult!.user.uid
            //                        db.collection("users").document(newUserID).setData(["AccountCreatedOn":accountCreationDate, "emailIsVerified": false])
            //
            //                        print("New user link created with id \(authResult!.user.uid) on \(accountCreationDate)")
            //                        self.moveToHome()
            //                        Auth.auth().currentUser?.sendEmailVerification { (error) in
            //                            if error == nil {
            //                                print("email verification sent")
            //                            }
            //                            else{
            //                            print(error!.localizedDescription)
            //                        }
            //                        }
            //                    }
            //                    else{
            //                        print("error creating account")
            //                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            //                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            //
            //                            alertController.addAction(defaultAction)
            //                        self.present(alertController, animated: true, completion: nil)
            //                        }
            //
            //
            //                }
            
            
        }
        
        
    }
    

   
    
    
 
}

//MARK:- extension for textfield delegate

extension SignUpViewController: UITextFieldDelegate {
    
    
    //move the keyboard focus to the next box or close if on the final box
    //once signup configured add in signup method
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
