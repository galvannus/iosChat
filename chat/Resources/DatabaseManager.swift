//
//  DatabaseManager.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 29/10/23.
//

import FirebaseDatabase
import Foundation

final class DatabaseManager {
    static let shared = DatabaseManager()

    private let database = Database.database().reference()
}

// MARK: - Account Management

extension DatabaseManager {
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
        ])
    }

    public func userExists(with email: String, completion: @escaping (Bool) -> Void) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }

            completion(true)
        })
    }
}
