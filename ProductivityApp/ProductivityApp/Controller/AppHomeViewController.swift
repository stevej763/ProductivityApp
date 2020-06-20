//
//  AppHomeViewController.swift
//  LoginTemplate
//
//  Created by Steve Jones on 17/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase
class AppHomeViewController: UIViewController {

    let firebaseAuth = Auth.auth()
    
    @IBOutlet weak var barProfileIcon: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imageURL: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // debug current user
        if let user = firebaseAuth.currentUser {
            
            getImage()
            //print(user.photoURL)
            profileImage.layer.cornerRadius = 60
            
            
            userEmail.text = user.email!
            userId.text = user.uid
            if let displayName = user.displayName {
                userDisplayName.text = displayName
            }
            if let imageUrl = user.photoURL {
                imageURL.text = imageUrl.absoluteString
            }
            
            
            
            
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
    

    
    @IBAction func logoutPressed(_ sender: UIButton) {
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
    
    func getImage(){

        
        if let imageUrl = self.firebaseAuth.currentUser?.photoURL {
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: imageUrl) { (data, response, error) in
                
                if error == nil && data != nil {
                    
                    let image = UIImage(data: data!)
                    
                    
                    DispatchQueue.main.async {
                        self.profileImage.image = image
                        //self.barProfileIcon.image = image
                    }
                    
                } else {
                    print(error!)
                }
                
                
                
            }
            dataTask.resume()
        }
        
    }
    
    
    
}


