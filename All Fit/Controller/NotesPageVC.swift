//
//  NotesPageVC.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/17/21.
//

import UIKit
import CoreData

class NotesPageVC: UIViewController, UITextViewDelegate {
    
    fileprivate var savedNote = [Notes]()
    @IBOutlet var textView: UITextView!
    @IBOutlet var backView: UIView!
    @IBOutlet var trashButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //Set up the textView by loading in from core data any text the user typed previously
        let fetchNotesRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        do{
            let fetchedNotesData = try PersistenceService.context.fetch(fetchNotesRequest)
            savedNote = fetchedNotesData
            if !savedNote.isEmpty{
                textView.text = savedNote[0].text
            }
        }
        catch{
            print("ERROR: Could not load saved data")
        }
        textView.backgroundColor = .white
        textView.textColor = .darkGray
        
        //Set up the back view on the header
        backView.backgroundColor = applyPowderRedColor()
        backView.layer.cornerRadius = 80
        
        //Set up the clear button
        trashButton.backgroundColor = applyPowderRedColor()
        trashButton.layer.cornerRadius = 25
        trashButton.tintColor = .white
    }
    
    //Perform the segue animation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "unwindHome"{
            //Set up unwind segue animation
            let xmarkButton = sender as! UIButton
            (segue as? cornerPopUp)?.circleOrigin = xmarkButton.center
            
            //Hide keyboard if up
            view.endEditing(true)
        }
    }
    
    //Once the view controller is dismissed, save the notes to core data
    override func viewWillDisappear(_ animated: Bool) {
        if isBeingDismissed && textView.text != ""{
            //Delete the previous entry
            if !savedNote.isEmpty{
                let notePreviousToDelete = savedNote[0]
                PersistenceService.context.delete(notePreviousToDelete)
                PersistenceService.saveContext()
            }
            
            //Add the new entry
            let notesEntry = Notes(context: PersistenceService.context)
            notesEntry.text = textView.text
            PersistenceService.saveContext()
        }
        //Handle case where user deletes the entire text manually
        else if isBeingDismissed && textView.text == ""{
            if !savedNote.isEmpty{
                let notePreviousToDelete = savedNote[0]
                PersistenceService.context.delete(notePreviousToDelete)
                savedNote.remove(at: 0)
                PersistenceService.saveContext()
            }
        }
    }
    
    //Dismiss the keyboard when clicking on the view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //Clear the text when button is clicked
    @IBAction func clearClicked(_ sender: Any){
        //Clear the text visually
        textView.text = nil
        
        //Clear the text from core data
        if !savedNote.isEmpty{
            let noteToDelete = savedNote[0]
            PersistenceService.context.delete(noteToDelete)
            savedNote.remove(at: 0)
            PersistenceService.saveContext()
        }
        
    }
    
    
}
