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
        let db = Firestore.firestore()
        var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var userEmailField: UILabel!
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var passwordCell: UITableViewCell!
    
    
    func checkForEmailUpdate(){
        guard let userId = auth.currentUser?.uid else {return}
        db.collection("users").document(userId)
        .addSnapshotListener { documentSnapshot, error in
          guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
          guard let data = document.data() else {
            print("Document data was empty.")
            return
          }
            print(data)
            
            guard let currentEmail = data["email"] as? String else {
                return
            }
            
            if currentEmail == self.auth.currentUser?.email {
                
                let currentDisplayName = data["displayName"] as! String
                self.userEmailField.text = data["email"] as? String
                self.title = "\(currentDisplayName)'s Settings"
                self.displayName.text = currentDisplayName
                
            } else {
                print("email changed")
                self.logout()
            }
            
            
            
        }
    }
    
    func updateSettingsTitle(){
        if let cloudDisplayName = auth.currentUser?.displayName {
        title = "\(cloudDisplayName)'s Settings"
            
        
        } else {
            title = "Settings"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSettingsTitle()
        checkForEmailUpdate()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        getProfilePicture()
        defineImagePicker()
        ProfileUpdateCellWasTapped()
        
        
        self.displayName.text = self.auth.currentUser?.displayName
        self.userEmailField.text = self.auth.currentUser?.email
        displayName.delegate = self
        
        auth.currentUser?.reload(completion: { (error) in
            self.displayName.text = self.auth.currentUser?.displayName
        })
        
        
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
            profilePictureView.image = UIImage(systemName: "person")
        }
        auth.currentUser?.reload(completion: { (error) in
            if error == nil {
                guard let imageUrl = self.auth.currentUser?.photoURL else {return}
                self.updateProfile.downloadProfilePicture(url: imageUrl) { (result, error) in
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

    fileprivate func logout(){
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "UnwindLogOut", sender: self)
            print("Logged Out")
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        logout()
    }
    
    //objective C function to present the image picker after tapping the current profile picture
    @objc func editProfilePicture(){
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    fileprivate func ProfileUpdateCellWasTapped() {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.editProfilePicture))
        formatProfilePicture(imageTap)
        
        let emailCellTap = UITapGestureRecognizer(target: self, action: #selector(self.emailRowPressed))
        emailCell.addGestureRecognizer(emailCellTap)
        
        let passwordCellTap = UITapGestureRecognizer(target: self, action: #selector(self.passwordRowPressed))
        passwordCell.addGestureRecognizer(passwordCellTap)
    }
    
    @objc func emailRowPressed(){
        var passwordField = UITextField()
        let alert = UIAlertController(title: "Enter your password to continue", message:"", preferredStyle: .alert)
        let action = UIAlertAction(title: "Submit", style: .default) { (action) in
            if passwordField.text != "" {
                guard let user = Auth.auth().currentUser else {return}
                
                let password = passwordField.text
                // Prompt the user to re-provide their sign-in credentials
                self.auth.signIn(withEmail: (user.email!), password: password!) { (authResult, error) in
                    if error != nil {
                        let passwordErrorAlert = UIAlertController(title: "Password Incorrect", message: "", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "Ok", style: .default)
                        passwordErrorAlert.addAction(defaultAction)
                        self.present(passwordErrorAlert, animated: true, completion: nil)
                        print("error logging user in")
                    } else {
                        print("user authenticated")
                        self.performSegue(withIdentifier: "UpdateEmailSegue", sender: self.emailCell)
                    }
                }
            } else {
                let passwordErrorAlert = UIAlertController(title: "Password Incorrect", message: "", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Ok", style: .default)
                passwordErrorAlert.addAction(defaultAction)
                self.present(passwordErrorAlert, animated: true, completion: nil)
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Password"
            alertTextField.textContentType = .password
            alertTextField.isSecureTextEntry = true
            passwordField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    @objc func passwordRowPressed(){
        print("Moving to update password page")
        self.performSegue(withIdentifier: "UpdatePasswordSegue", sender: self)
        
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
