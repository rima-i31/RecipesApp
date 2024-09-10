//
//  AddNoteViewController.swift
//  intershipApp
//
//  Created by Rima Mihova on 09.09.2024.
//

import UIKit

class AddNoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var noteTextView: UITextView!
    var idRecipe: String?
    var noteToEdit: Notes?
    
    var isNoteSaved = false
    var isTitleComplete = false
    var titleText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        
        noteTextView.delegate = self
        configureTextView()
        if let note = noteToEdit {
            noteTextView.text = "\(note.title ?? "")\n\(note.note ?? "")"
        }
    }
    
    private func configureTextView() {
        noteTextView.font = UIFont.systemFont(ofSize: 20)
        noteTextView.textColor = UIColor.white
    }
    
    @objc func doneButtonTapped() {
        saveNote()
        isNoteSaved = true
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent && !isNoteSaved {
            saveNote()
        }
    }
    private func saveNote() {
        guard let noteText = noteTextView.text, !noteText.isEmpty else { return }
        let components = noteText.components(separatedBy: "\n")
        let title = components.first ?? ""
        let noteTextWithoutTitle = components.dropFirst().joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        
        let date = Date()
        
        if let existingNote = noteToEdit {
            CoreDataManager.shared.updateNote(noteID: existingNote.objectID, title: title, noteText: noteTextWithoutTitle, date: date)
        } else if let recipeId = idRecipe {
            let noteId = UUID().uuidString
            CoreDataManager.shared.addNote(title: title, noteText: noteTextWithoutTitle, date: date, idRecipe: recipeId, idNote: noteId)
        }
    }
    
}
