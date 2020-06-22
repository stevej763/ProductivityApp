//
//  AppHomeViewController.swift
//  LoginTemplate
//
//  Created by Steve Jones on 17/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase
class UserAccountSettingsViewController: UITableViewController {

    let firebaseAuth = Auth.auth()
    

    @IBOutlet weak var ProfilePictureView: UIImageView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // debug current user
        if let user = firebaseAuth.currentUser {
            
            title = "Hello, \(user.displayName!)"

            getProfilePicture()
            ProfilePictureView.layer.cornerRadius = 60
            

            
            
            
            
            //profileImage.image = UIImage
            
        }
        
        
    }
    
    

    
    
    //hide the nav bar when the view appears
    override func viewWillAppear(_ animated: Bool) {
       // navigationController?.setNavigationBarHidden(true, animated: false)


         }
    
    //undo hiding the nav bar
    override func viewWillDisappear(_ animated: Bool) {
       // navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    
    func logout() {
        do {
               try Auth.auth().signOut()

                self.performSegue(withIdentifier: "UnwindLogOut", sender: self)
                print("Logged Out")
            
           }
        catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
           }
        
    
        
        
        
    }
    
    
    //MARK:- Get image from profile url
    
    func getProfilePicture(){
        
        //gets the local version of users profile picture for quick loading
        guard let user = Auth.auth().currentUser?.uid else {return}
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent(user)
        
        do {
            let image = try Data(contentsOf: url)
            
            ProfilePictureView.image = UIImage(data: image)
            
            print(documents.absoluteURL)
        } catch {
            print("error loading image \(error.localizedDescription)")
        }
        
        
        //updates the local image with the one stored in firebase for up-to-date cloud details
        if let imageUrl = self.firebaseAuth.currentUser?.photoURL {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: imageUrl) { (data, response, error) in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.ProfilePictureView.image = image
                    }
                } else {
                    print(error!)
                }
            }
            dataTask.resume()
        }
    }
    
    
    
    
    
    
}

//MARK:- Settings TableView

