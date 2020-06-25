//
//  ViewController.swift
//  LoginTemplate
//
//  Created by Steve Jones on 16/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase

class SignedOutViewController: UIViewController {

let auth = Auth.auth()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    @IBOutlet weak var LogoView: UIView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatView()
        
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        
        
        //check if user has logged in already

    }
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {}
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "AlreadyLoggedIn", sender: self)
            print("already logged in")
        }
        
        
        //debug logout user
        if Auth.auth().currentUser?.uid != nil{
            print("Current user ID: \(auth.currentUser!.uid)")
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
 
    @IBAction func signUpButtonPressed(_ sender: Any) {
        print("sign up pressed")
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("login button pressed")
    }
    
    
   
    
    
   //MARK:- editing the view to make it look nice
    fileprivate func formatView() {
          // Do any additional setup after loading the view.
          
          
          LogoView.layer.cornerRadius = 100.0
          LogoView.layer.borderWidth = 5.0
          LogoView.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
          
          LoginButton.layer.cornerRadius = 25.0
          LoginButton.layer.borderWidth = 5.0
          LoginButton.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
          
          SignUpButton.layer.borderWidth = 5.0
          SignUpButton.layer.borderColor = UIColor(named: "WetAsphalt")?.cgColor
          SignUpButton.layer.cornerRadius = 25.0
      }
    
    


}

