//
//  ContactListViewController.swift
//  UserDefaults
//
//  Created by Алексей Турулин on 6/26/23.
//

import UIKit

protocol ContactInfoViewControllerDelegate: AnyObject {
    func add(note: Note)
}

final class ContactListViewController: UITableViewController {
    
    // MARK: - Private Properties
    private var notes: [Note] = []
    
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let contactVC = segue.destination as? ContactInfoViewController else { return }
        contactVC.delegate = self
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ContactInfoViewControllerDelegate
extension ContactListViewController: ContactInfoViewControllerDelegate {
    func add(note: Note) {
        notes.append(note)
        tableView.reloadData()
    }
}
