//
//  SignUpViewController.swift
//  LoginTemplate
//
//  Created by Steve Jones on 17/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    var imagePicker: UIImagePickerController!
    
    //firebase authentication
    let auth = Auth.auth()
    //firestore for profile picture
    let storage = Storage.storage()
    //database instance
    let db = Firestore.firestore()
    //profile update model instance
    let profileUpdate = ProfileUpdate()
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var fieldBackground: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmationField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view formatting
        formatView()
        //add delegates
        emailTextField.delegate = self
        passwordField.delegate = self
        displayNameField.delegate = self
        passwordConfirmationField.delegate = self
        //close keyboard on tap
        let viewWasTapped = UITapGestureRecognizer(target:self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(viewWasTapped)
        //openImagePickerOnTap
        let profilePictureWasTapped = UITapGestureRecognizer(target: self, action: #selector(self.addProfilePicture))
        profilePicture.addGestureRecognizer(profilePictureWasTapped)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        print("sign up button pressed!")
        //error messages for blank boxes
        if emailTextField.text == "" {
            Alert.showBasicAlert(on: self, with: "Email Required", message: "Please enter a valid email address.")
            return
        }
        if displayNameField.text == "" {
            Alert.showBasicAlert(on: self, with: "Display Name Required", message: "Please enter a display name.")
            return
        }
        if passwordField.text == "" {
            
            Alert.showBasicAlert(on: self, with: "Password Invalid", message: "Please enter a password")
            return
        }
        if passwordField.text != passwordConfirmationField.text {
            Alert.showBasicAlert(on: self, with: "Passwords do not match", message: "Please re-type password")
            return
        }
        else {
            //firebase authentication
            Auth.auth().createUser(withEmail: emailTextField.text!.removeExtraSpaces(), password: passwordField.text!){ (authResult, error) in
                if error == nil {
                    let accountCreationDate = Date().timeIntervalSince1970
                    self.db.collection("users").document(authResult!.user.uid).setData(["accountCreatedOn":accountCreationDate, "email":self.emailTextField.text!, "emailIsVerified": false])
                    print("New user link created with id \(authResult!.user.uid) on \(accountCreationDate)")
                    self.profileUpdate.updateDisplayName(newDisplayName: self.displayNameField.text!)
                    self.profileUpdate.updateProfilePicture(image: self.profilePicture)
                    //send user email verification next - need to add
                }
                else{
                    print("error creating account")
                    Alert.showBasicAlert(on: self, with: "Error", message: error!.localizedDescription)
                    return
                }
            }
        }
    }
    
    
    //make the view look nice
    fileprivate func formatView() {
        //set field background
        fieldBackground.backgroundColor = UIColor(named: "MidnightBlue")
        fieldBackground.alpha = 0.9
        fieldBackground.layer.cornerRadius = 8.0
        fieldBackground.layer.borderWidth = 5
        fieldBackground.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
        
        signUpButton.layer.cornerRadius = 25.0
        
        profilePicture.layer.cornerRadius = 50
        profilePicture.isUserInteractionEnabled = true
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func addProfilePicture(){
        print("Profile Image Being Selected")
        //presents the iamge picker for the profile photo selection
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
}

//MARK:- extension for textfield delegate

extension SignUpViewController: UITextFieldDelegate {
    //move the keyboard focus to the next box or close if on the final box
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.displayNameField.becomeFirstResponder()
        }
        if textField == self.displayNameField {
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

//MARK:- image picker delegate functions


extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //close picker when cancel pressed
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            //set profile picture image as the selected image after editing
            self.profilePicture.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Sting Extensions


extension String {
    func removeExtraSpaces() -> String {
        //extension to remove trailing spaces in the email field (casues firebase error)
        return self.replacingOccurrences(of: "[\\s\n]+", with: "", options: .regularExpression, range: nil)
    }
}
