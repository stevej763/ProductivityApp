//
//  ViewController.swift
//  LoginTemplate
//
//  Created by Steve Jones on 16/06/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit

class SignInHomeViewController: UIViewController {

    
    @IBOutlet weak var LogoView: UIView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        LogoView.layer.cornerRadius = 100.0
        LoginButton.layer.cornerRadius = 25.0
        SignUpButton.layer.cornerRadius = 25.0
    }
    
    
    @IBAction func LoginButtonPressed(_ sender: UIButton) {
        print("login pressed")
    }
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        print("sign up pressed")
    }
    


}

