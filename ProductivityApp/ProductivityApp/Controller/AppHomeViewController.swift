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
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imageURL: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userDisplayName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // debug current user
        if let user = firebaseAuth.currentUser {
            
            
            print(user.photoURL)
            
            
            
            
            
            userEmail.text = user.email!
            userId.text = user.uid
            userDisplayName.text = user.displayName!
            imageURL.text = user.photoURL?.absoluteString
            
            
            
            //profileImage.image = UIImage
            
        }
        
        
    }
    
    //hide the nav bar when the view appears
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    

         }
    
    //undo hiding the nav bar
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
               try Auth.auth().signOut()
                print("Logged Out")
           }
        catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
           }
        
    
        
        
        
    }
}


