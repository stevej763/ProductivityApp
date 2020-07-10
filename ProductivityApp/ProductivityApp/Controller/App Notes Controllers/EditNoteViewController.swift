//
//  EditNoteViewController.swift
//  ProductivityApp
//
//  Created by Steve Jones on 04/07/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase

class EditNoteViewController: UIViewController {
    
    let auth = Auth.auth()
    let db = Firestore.firestore()


    @IBOutlet weak var noteTitleField: UITextField!
    @IBOutlet weak var noteBodyField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteBodyField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        var title = ""
        
        if let user = auth.currentUser?.uid {
            
            if noteTitleField.text == "" {
                title = "Untitled Note"
            } else {
                title = noteTitleField.text!
            }
            
            
            
            db.collection(K.FStore.userCollection).document(user).collection(K.FStore.notesCollection).addDocument(data: [
                K.FStore.Excrept.titleField : title,
                K.FStore.Excrept.excerptField : noteBodyField.text!,
                K.FStore.Excrept.updatedOnField : Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an error: \(e)")
                } else {
                    print("note added")
                }
            }
        }
    }

}


extension EditNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let titleAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor : UIColor.white
        ]
        let bodyAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor : UIColor.black
        ]
        if textView.text == "" {
            textView.typingAttributes = titleAttributes
        } else {
            textView.typingAttributes = bodyAttributes
        }
    }
}
