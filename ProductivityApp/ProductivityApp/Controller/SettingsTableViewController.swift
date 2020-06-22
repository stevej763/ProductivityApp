//
//  SettingsTableViewController.swift
//  ProductivityApp
//
//  Created by Steve Jones on 21/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {

        let firebaseAuth = Auth.auth()
    
        var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var profilePictureVIew: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProfilePicture()

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.editProfilePicture))
               
               
               
               
               profilePictureVIew.isUserInteractionEnabled = true
               profilePictureVIew.addGestureRecognizer(tap)
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        
        
        profilePictureVIew.layer.cornerRadius = 60
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

    

    @objc func editProfilePicture(){
        print("picking new profile image picture")
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    
    
    //MARK:- Get image from profile url, first from local storage, then update with cloud version to keep up to date
    
    func getProfilePicture(){
        
        //gets the local version of users profile picture for quick loading
        guard let user = Auth.auth().currentUser?.uid else {return}
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(user)
        
        do {
            let image = try Data(contentsOf: url)
            
            profilePictureVIew.image = UIImage(data: image)
            
            print(documents.absoluteURL)
        } catch {
            print("error loading image \(error.localizedDescription)")
        }
        
        
        //updates the displayed image with the one stored in firebase for up-to-date cloud details
        if let imageUrl = self.firebaseAuth.currentUser?.photoURL {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: imageUrl) { (data, response, error) in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.profilePictureVIew.image = image
                        
                        //update the local image with the most recent cloud image if available
                        self.saveLocalImage(forUser: user, image: data!)
                        
                    }
                } else {
                    print(error!)
                }
            }
            dataTask.resume()
        }
    }
    
    func saveLocalImage(forUser user: String, image imageData: Data){
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(user)
        
        do {
            try imageData.write(to: url)
            print("saving profile picture locally")
        } catch {
            print("error saving image to disk \(error)")
        }
        
    }
    
    
    
    
}




extension SettingsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let pickedImage = info[.editedImage] as? UIImage {
            self.profilePictureVIew.image  = pickedImage
            
            
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}
