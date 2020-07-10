//
//  NotesListViewController.swift
//  ProductivityApp
//
//  Created by Steve Jones on 04/07/2020.
//  Copyright © 2020 95Design. All rights reserved.
//

import UIKit
import Firebase

class NotesListViewController: UIViewController {

    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    
    var notes: [NoteExcerpt] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(UINib(nibName: K.noteCellNibName, bundle: nil), forCellReuseIdentifier: K.noteCellidentifier)
    }
    
    func loadNotes() {
        
        if let userId = auth.currentUser?.uid {
            print(userId)
            db.collection(K.FStore.userCollection)
                .document(userId)
                .collection(K.FStore.notesCollection)
                .order(by: K.FStore.Excrept.updatedOnField)
                .addSnapshotListener { (querySnapshot, error) in
                    self.notes = []
                    if let e = error {
                        Alert.showBasicAlert(on: self, with: "Error Retreving Notes", message: e.localizedDescription)
                        print(e)
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            for newDoc in snapshotDocuments {
                                let data = newDoc.data()
                                if let noteTitle = data[K.FStore.Excrept.titleField] as? String, let noteExcerpt = data[K.FStore.Excrept.excerptField] as? String, let noteEdited = data[K.FStore.Excrept.updatedOnField] as? Double
                                {
                                    print("Success")
                                    let newNote = NoteExcerpt(title: noteTitle, excerpt: noteExcerpt, dateEdited: noteEdited)
                                    print("New note loaded with title: \(newNote.title)")
                                    self.notes.append(newNote)
                                    DispatchQueue.main.async {
                                         self.tableView.reloadData()
                                    }
                                   
                                } else {
                                    print("error with note fields")
                                }
                                
                            }
                        }
                    }            }
        }
        
        
    }

}


extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(notes.count)
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.locale = NSLocale.current
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let date = Date(timeIntervalSince1970: note.dateEdited)
        let formattedDate = formatter.string(from: date)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.noteCellidentifier, for: indexPath) as! NoteCell
        
        cell.noteTitleLabel.text = note.title
        cell.noteExcerptLabel.text = note.excerpt
        cell.noteLastEditedLabel.text = formattedDate
        
        return cell
    }
    
    
    
    
    
}
