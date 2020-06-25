//
//  SettingsTableViewController.swift
//  ProductivityApp
//
//  Created by Steve Jones on 21/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {

        let auth = Auth.auth()
        let storage = Storage.storage()
        let updateProfile = ProfileUpdate()
    
        var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        getProfilePicture()
        defineImagePicker()
        self.displayName.text = self.auth.currentUser?.displayName
        self.emailField.text = self.auth.currentUser?.email
        displayName.delegate = self
        auth.currentUser?.reload(completion: { (error) in
            self.displayName.text = self.auth.currentUser?.displayName
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.editProfilePicture))
        formatProfilePicture(tap)
        
    
       
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    func formatProfilePicture(_ tap: UITapGestureRecognizer) {
        profilePictureView.isUserInteractionEnabled = true
        profilePictureView.addGestureRecognizer(tap)
        profilePictureView.layer.cornerRadius = 60
    }
    
    
    //MARK:- Display Name
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == displayName {
            if textField.text != "" {
                updateProfile.updateDisplayName(newDisplayName: textField.text!)
                self.view.endEditing(true)
            }
            
            
            print("setting display name")
            return true
        }
        if textField == emailField {
            
        }
        
        
        
        return true
    }
    
    
    
    
    
    
    
    
    //MARK:- retrieving profile picture
    
    func getProfilePicture(){
        //gets the local version of users profile picture for quick loading
        guard let user = Auth.auth().currentUser?.uid else {return}
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(user)
        do {
            let image = try Data(contentsOf: url)
            profilePictureView.image = UIImage(data: image)
        } catch {
            print("error loading image \(error.localizedDescription)")
        }
        auth.currentUser?.reload(completion: { (error) in
            if error == nil {
                let imageUrl = self.auth.currentUser?.photoURL
                self.updateProfile.downloadProfilePicture(url: imageUrl!) { (result, error) in
                    if error != nil {
                        print("There was an error downloading the profile picture")
                    } else {
                        self.profilePictureView.image = result
                    }
                }
            }
        })
    }
    
    //MARK:- log out of app

    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        do {
               try Auth.auth().signOut()

                self.performSegue(withIdentifier: "UnwindLogOut", sender: self)
                print("Logged Out")
            
           }
        catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
           }

    }
    
    
    //objective C function to present the image picker after tapping the current profile picture
    @objc func editProfilePicture(){
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 3
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    

    
    
    
    
    
}










//MARK:- image picker extension
extension SettingsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func defineImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }

    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage {
            self.profilePictureView.image  = pickedImage
            //also update firebase profile picture and local image
            updateProfile.updateProfilePicture(image: self.profilePictureView)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
