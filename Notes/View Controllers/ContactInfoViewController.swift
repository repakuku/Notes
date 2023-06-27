//
//  AddContactViewController.swift
//  UserDefaults
//
//  Created by Алексей Турулин on 6/26/23.
//

import UIKit

final class ContactInfoViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet var doneButton: UIBarButtonItem!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var textField: UITextField!
    
    // MARK: - Public Properties
    unowned var delegate: ContactInfoViewControllerDelegate!
    
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
        guard let title = titleTextField.text else { return }
        guard let text = textField.text else { return }
        
        let note = Note(title: title, text: text)
        
        delegate.add(note: note)
        navigationController?.popViewController(animated: true)
    }
}
