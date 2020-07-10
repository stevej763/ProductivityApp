//
//  ProfileUpdate.swift
//  ProductivityApp
//
//  Created by Steve Jones on 25/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase




struct ProfileUpdate {
    
    let storage = Storage.storage()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    
    
    func updateDisplayName(newDisplayName: String) {
        guard let userId = auth.currentUser?.uid else {
            print("updateDisplayName failed")
            return
        }
        db.collection("users").document(userId).updateData(["displayName":newDisplayName])
        
        
        let changeRequest = self.auth.currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = newDisplayName
        changeRequest?.commitChanges(completion: { error in
            if error != nil {
                print("There was an error updating the display name \(error.debugDescription)")
                
                
            } else {
                print("user profile updated")
                
            }
        })
    }
    
    func updateEmail(newEmail: String){
        let userId = auth.currentUser?.uid
        db.collection("users").document(userId!).updateData(["email":newEmail])
    }
    
    
    func logout(){
        do {
            try Auth.auth().signOut()
            print("Logged Out")
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
    
    //save the new profile picture image locally
    func saveLocalImage(forUser user: String, image imageData: Data){
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(user)
        
        do {
            try imageData.write(to: url)
        } catch {
            print("error saving image to disk \(error)")
        }
        
    }
    
    
    
    //update the current users profile picture
    func updateProfilePicture(image profilePicture: UIImageView) {
        guard let user = auth.currentUser?.uid else {return}
        let storageRef = storage.reference()
        let profileRef = storageRef.child(user).child("\(user).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        if let imageData = profilePicture.image!.jpegData(compressionQuality: 0.7) {
            saveLocalImage(forUser: user, image: imageData)
            profileRef.putData(imageData, metadata: metadata) { (response, error) in
                if error != nil {
                    print("Error at saving photo")
                    print(error!.localizedDescription)
                    return
                } else {
                    profileRef.downloadURL { (url, error) in
                        if let imageURL = url?.absoluteString {
                            let changeRequest = self.auth.currentUser?.createProfileChangeRequest()
                            changeRequest?.photoURL = URL(string: imageURL)
                            changeRequest?.commitChanges(completion: { error in
                                if error != nil {
                                    print("There was an error updating the profile picture \(error.debugDescription)")
                                } else {
                                    print("user profile updated")
                                }
                            })
                        }
                    }
                }
            }
        }
        
    }
    
    //function to download the current users profile picutre from firebase
    func downloadProfilePicture(url imageUrl: URL, completion: @escaping (_ result: UIImage?, _ error: Error?) -> Void) {
        let user = auth.currentUser?.uid
        let session = URLSession.shared
        let dataTask = session.dataTask(with: imageUrl) { (data, response, error) in
            if error == nil && data != nil {
                let image = UIImage(data: data!)
                self.saveLocalImage(forUser: user!, image: data!)
                DispatchQueue.main.async {
                    completion(image, error)
                }
            } else {
                print(error!)
                let image: UIImage? = nil
                completion(image!, error)
                
            }
        }
        //start data task
        dataTask.resume()
        
        
    }
    
    
    
    
    
    
}
