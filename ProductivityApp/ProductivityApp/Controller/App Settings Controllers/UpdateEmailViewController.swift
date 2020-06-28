//
//  UpdateEmailViewController.swift
//  ProductivityApp
//
//  Created by Steve Jones on 26/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase

class UpdateEmailViewController: UIViewController {

    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    let profileUpdate = ProfileUpdate()
    
    
    @IBOutlet weak var emailUpdateButton: UIButton!
    @IBOutlet weak var currentEmaillabel: UILabel!
    @IBOutlet weak var newEmailTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentEmaillabel.text = "Your current account email is: \(user!.email!.description)"
        emailUpdateButton.layer.cornerRadius = 25
        newEmailTextField.keyboardType = .emailAddress

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func updateEmailPressed(_ sender: UIButton) {
        if newEmailTextField.text != "" {
            user?.updateEmail(to: newEmailTextField.text!, completion: { (error) in
                if error != nil {
                    switch error!.localizedDescription {
                    case "The email address is already in use by another account.":
                        self.errorMessageLabel.textColor = .red
                        self.errorMessageLabel.text = "That email is already in use, please enter a different email address"
                    case "The email address is badly formatted.":
                        self.errorMessageLabel.textColor = .red
                        self.errorMessageLabel.text = "Please enter a valid email address and try again."
                    default:
                        self.errorMessageLabel.textColor = .red
                        self.errorMessageLabel.text = error!.localizedDescription
                    }
                    
                    print(error?.localizedDescription)
                } else {
                    self.profileUpdate.updateEmail(newEmail: self.newEmailTextField.text!)
                        self.dismiss(animated: true)
                    
                    
                    
                }
                
            })
            
        } else {
            
        }
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
