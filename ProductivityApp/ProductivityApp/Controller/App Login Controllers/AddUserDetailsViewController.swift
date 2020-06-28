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
    let db = Firestore.firestore()

    
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
        imagePicker.sourceType = .photoLibrary
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
    
    
    func updateUserProfile(){
        view.endEditing(true)
        //add animation here to show the app is doing something
        print("update user pressed")
        
        
        //save displayName
        let profileUpdate = ProfileUpdate()
        profileUpdate.updateDisplayName(newDisplayName: self.displayNameField.text!)
        
        
        
        //check there is a current user
        guard let user = auth.currentUser?.uid else {return}
        
        //create firebase storage reference
        let storageRef = storage.reference()
        //create folder structure in storage reference
        let profileRef = storageRef.child(user).child("\(user).jpg")
        //init metadata
        let metadata = StorageMetadata()
        //set file type
        metadata.contentType = "image/png"
        
        //convert UIImage to jpeg data
        if let imageData = self.profilePicture.image?.jpegData(compressionQuality: 0.7) {
            
            //store a local copy of the image here for quick access in app
            saveLocalImage(forUser: user, image: imageData)
            
            //send data to the firebase storage for cloud access
            profileRef.putData(imageData, metadata: metadata) { (response, error) in
                if error != nil {
                    //if there is an error sending the data, print error (need to add notification here)
                    print("Error at saving photo")
                    print(error!.localizedDescription)
                    //exit closure
                    return
                } else {
                    //get the download url for the uploaded image
                    profileRef.downloadURL { (url, error) in
                        if let imageURL = url?.absoluteString {
                            let changeRequest = self.auth.currentUser?.createProfileChangeRequest()
                            changeRequest?.photoURL = URL(string: imageURL)
                            changeRequest?.displayName = self.displayNameField.text
                            changeRequest?.commitChanges(completion: { error in
                                if error != nil {
                                    print("There was an error updating the profile picture \(error.debugDescription)")
                                    
                                } else {
                                    print("user profile updated")
                                    self.performSegue(withIdentifier: "ProfileCompleteSegue", sender: self)
                                }
                            })
                        }
                    }
                }
            }
            
        }
        
        
        
    }
    
    
    
    //open the image picker when progile picture temlate pressed
    @objc func addProfilePicture(){
        print("clicked!")
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    //MARK:-  format and make the view look nicer
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
    
    
    
    
    //MARK:- save profile image to local storage for quick access
    func saveLocalImage(forUser user: String, image imageData: Data){
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(user)
        
        do {
            try imageData.write(to: url)
            print(documents.absoluteURL)
        } catch {
            print("error saving image to disk \(error)")
        }
        
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
