//
//  AddUserDetailsViewController.swift
//  ProductivityApp
//
//  Created by Steve Jones on 19/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase

class AddUserDetailsViewController: UIViewController {
    
    let auth = Auth.auth()
    let storage = Storage.storage()
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var displayNameField: UITextField!
    @IBOutlet weak var enterAppButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatView()

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.addProfilePicture))
        
        
        
        
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tap)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        //imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
       
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    //TODO - update this logic to make sure it wont error and add a user prompt if there is an error!
    @IBAction func enterButtonPressed(_ sender: UIButton) {
        if displayNameField.text != "" {
            updateUserProfile()
            
        } else {
            displayNameField.placeholder = "Add a display name here"
        }
    }
    
    
    
    
    
    // segue to app home if skip button pressed
    @IBAction func skipButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "profileSkippedSegue", sender: self)
    }
    
    
    
    
    
    
    func updateUserProfile(){
        view.endEditing(true)
        //add animation here to show the app is doing something
        
        
        
        guard let user = auth.currentUser?.uid else {return}
        let storageRef = storage.reference()
        let profileRef = storageRef.child(user).child("\(user).png")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        if let imageData = self.profilePicture.image?.pngData() {
            
            profileRef.putData(imageData, metadata: metadata) { (response, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                } else {
                    profileRef.downloadURL { (url, error) in
                        if let imageURL = url?.absoluteString {
                            print(imageURL)
                            
                            
                            
                            
                            
                            
                            let changeRequest = self.auth.currentUser?.createProfileChangeRequest()
                            changeRequest?.photoURL = URL(string: imageURL)
                            
                            changeRequest?.commitChanges(completion: { error in
                                if error == nil {
                                    print("user profile picture updated")
                                    self.performSegue(withIdentifier: "ProfileCompleteSegue", sender: self)
                                } else {
                                    print("There was an error updating the profile picture \(error.debugDescription)")
                                }
                            })
                        }
                    }
                }
            }
            
        }
        
        
        
        
        
     
        
        
        
        
        
        
        
        let changeRequest = auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayNameField.text
        
        print("display name updated")
        changeRequest?.commitChanges(completion: { error in
            if error == nil {
                print("user display name changed")
            } else {
                print("There was an error updating the username \(error.debugDescription)")
            }
        })
    }
    
    
    
    //open the image picker when progile picture temlate pressed
    @objc func addProfilePicture(){
        print("clicked!")
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    //make the view look nicer
    fileprivate func formatView() {
        userInfoView.backgroundColor = UIColor(named: "MidnightBlue")
        userInfoView.alpha = 0.9
        userInfoView.layer.cornerRadius = 8.0
        userInfoView.layer.borderWidth = 5
        userInfoView.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
        
        
        enterAppButton.layer.cornerRadius = 25
        profilePicture.layer.cornerRadius = 60
        profilePicture.isUserInteractionEnabled = true
    }
    
}

extension AddUserDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let pickedImage = info[.editedImage] as? UIImage {
            self.profilePicture.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
