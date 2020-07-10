//
//  alert.swift
//  ProductivityApp
//
//  Created by Steve Jones on 03/07/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit


struct Alert {
    
    
    static func showBasicAlert(on vc:UIViewController, with title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(defaultAction)
        vc.present(alert, animated: true, completion: nil)
    }
    
    
}
