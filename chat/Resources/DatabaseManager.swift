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

    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

// MARK: - Account Management

extension DatabaseManager {
    /// Inserts new user to database
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName,
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to write to database.")
                completion(false)
                return
            }

            // Add array of users
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                // Check if the collection exists
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // Append dictionary
                    let newElement = [
                        "name": user.firstName + " " + user.lastName,
                        "email": user.safeEmail,
                    ]
                    usersCollection.append(newElement)

                    self.database.child("users").setValue(usersCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                } else {
                    // Create array
                    let newCollection: [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail,
                        ],
                    ]

                    self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            /**

             users[
                 [
                     "name":
                     "safe_email":
                 ],
                 [
                     "name":
                     "safe_email":
                 ]
             ]

              */
        })
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

    public func getAllUsers(completion: @escaping (Result<[[String: String]], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String: String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }

            completion(.success(value))
        })
    }

    public enum DatabaseError: Error {
        case failedToFetch
    }
}

// MARK: - Sending Messages / Conversations

extension DatabaseManager {
    
    //Creates a new conversation with target user, email and first message sent
    public func createNewConversation(width otherUserEmail: String, firstMessage: Message, completion: @escaping (Bool) -> Void){
        
    }
    
    //Fetch and returns all conversations for the user with passed in email
    public func getAllConversations(for email: String, completion: @escaping (Result<String, Error>) -> Void){
        
    }
    
    //Get all messages for a given conversation
    public func getAllMessagesForConversation(with id: String, completion: (Result<String, Error>) -> Void){
        //
    }
    
    //Sends a message with target conversation and message
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void){
        
    }
}
