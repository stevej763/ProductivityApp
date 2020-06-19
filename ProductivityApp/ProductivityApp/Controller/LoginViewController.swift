//
//  LoginViewController.swift
//  LoginTemplate
//
//  Created by Steve Jones on 17/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var credentialBackground: UIView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatView()
        
        //delegates to check where keybaord is
        userEmailField.delegate = self
        userPasswordField.delegate = self
        
        //close keyboard on tap
        let tap = UITapGestureRecognizer(target:self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    

    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("Login button was pressed")
    
        //animate login button when pressed
        UIView.animate(withDuration: 0.1, animations: {
            self.loginButton.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (true) in
            UIView.animate(withDuration: 0.1) {
                self.loginButton.transform = .identity
            }
        }
        firebaseAuth()
    }
    
    
    
 //MARK:- make the page look nicer
    fileprivate func formatView() {
        credentialBackground.backgroundColor = UIColor(named: "MidnightBlue")
        credentialBackground.alpha = 0.9
        credentialBackground.layer.cornerRadius = 8.0
        credentialBackground.layer.borderWidth = 5
        credentialBackground.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
        
        loginButton.layer.cornerRadius = 25.0
        loginButton.layer.borderWidth = 5.0
        loginButton.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
    }
    
    
    
    //authenticate user with firebase
     func firebaseAuth() {
        //do firebase authentication here
        Auth.auth().signIn(withEmail: userEmailField.text!, password: userPasswordField.text!) { (authResult, error) in
            if error == nil{
                self.performSegue(withIdentifier: " LoginToHome", sender: self)
                print("logging user in")
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                print("error logging user in")
            }
        }
    }
    
    
    
    
}

extension LoginViewController: UITextFieldDelegate {
    
    //runs when the keyboard return key is pressed to move the cursor to the next box
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
