//
//  StorageManager.swift
//  Notes
//
//  Created by Алексей Турулин on 6/26/23.
//

import Foundation

final class StorageManager {

    static let shared = StorageManager()

    private let userDefaults = UserDefaults.standard
    private let key = "notes"
    
    private init() {}
    
    func fetchNotes() -> [Note] {
        guard let data = userDefaults.data(forKey: key) else { return [] }
        guard let notes = try? JSONDecoder().decode([Note].self, from: data) else { return [] }
        return notes
    }
    
    func save(note: Note) {
        var notes = fetchNotes()
        notes.append(note)
        guard let data = try? JSONEncoder().encode(notes) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func edit(note: Note, at index: Int) {
        var notes = fetchNotes()
        notes[index] = note
        guard let data = try? JSONEncoder().encode(notes) else { return }
        userDefaults.set(data, forKey: key)
    }
    
    func deleteNote(at index: Int) {
        var notes = fetchNotes()
        notes.remove(at: index)
        guard let data = try? JSONEncoder().encode(notes) else { return }
        userDefaults.set(data, forKey: key)
    }
    
}
