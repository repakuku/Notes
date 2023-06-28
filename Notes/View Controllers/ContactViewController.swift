//
//  ContactViewController.swift
//  Notes
//
//  Created by Алексей Турулин on 6/26/23.
//

import UIKit

enum Mode {
    case createNewNote
    case editCurrentNote
}

final class ContactViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var textField: UITextField!
    
    // MARK: - Public Properties
    unowned var delegate: ContactInfoViewControllerDelegate!
    var note: Note!
    var index: Int!
    var mode: Mode!
    
    // MARK: - Private Properties
    private let storageManager = StorageManager.shared
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false
        
        let action = UIAction { [weak self] _ in
            guard let title = self?.titleTextField.text else { return }
            self?.doneButton.isEnabled = !title.isEmpty
        }
        
        titleTextField.addAction(action, for: .editingChanged)
        
        if mode == .editCurrentNote {
            doneButton.isEnabled = true
            titleTextField.text = note.title
            textField.text = note.text
        }
    }

    // MARK: - Overrided Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        save()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private Methods
    private func save() {
        switch mode {
        case .createNewNote:
            guard let title = titleTextField.text else { return }
            guard let text = textField.text else { return }
            let note = Note(title: title, text: text)
            storageManager.save(note: note)
            delegate.add(note: note)
        case .editCurrentNote:
            note.title = titleTextField.text ?? ""
            note.text = textField.text ?? ""
            storageManager.edit(note: note, at: index)
            delegate.edit(note: note, at: index)
        case .none:
            break
        }
        navigationController?.popViewController(animated: true)
    }
}
