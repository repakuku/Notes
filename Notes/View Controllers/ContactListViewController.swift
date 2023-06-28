//
//  ContactListViewController.swift
//  UserDefaults
//
//  Created by Алексей Турулин on 6/26/23.
//

import UIKit

protocol ContactInfoViewControllerDelegate: AnyObject {
    func add(note: Note)
    func edit(note: Note, at index: Int)
}

final class ContactListViewController: UITableViewController {

    // MARK: - Private Properties
    private var notes: [Note] = []
    private let storageManager = StorageManager.shared
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        notes = storageManager.fetchNotes()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contactVC = segue.destination as? ContactInfoViewController else { return }
        contactVC.delegate = self
        
        if segue.identifier == "showCurrentNote" {
            guard let indexPath = sender as? IndexPath else { return }
            let index = indexPath.row
            contactVC.index = index
            contactVC.note = notes[index]
            contactVC.mode = .editCurrentNote
        } else {
            contactVC.mode = .createNewNote
        }
    }
}

// MARK: - UITableViewDataSource
extension ContactListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Note", for: indexPath)
        let note = notes[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = note.title
        content.secondaryText = note.text
        
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCurrentNote", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = indexPath.row
            notes.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            storageManager.deleteNote(at: index)
        }
    }
}

// MARK: - ContactInfoViewControllerDelegate
extension ContactListViewController: ContactInfoViewControllerDelegate {
    func add(note: Note) {
        notes.append(note)
        tableView.reloadData()
    }
    
    func edit(note: Note, at index: Int) {
        notes[index] = note
        tableView.reloadData()
    }
}
