//
//  ChatViewController+Delegates.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 15/11/23.
//

import InputBarAccessoryView
import MessageKit
import UIKit

extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = selfSender,
              let messageId = createMessageId() else {
            return
        }

        print("Sending: \(text)")
        
        let message = Message(messageId: messageId, sentDate: Date(), kind: .text(text), sender: selfSender)

        // Send Message
        if isNewConversation {
            // Create conversation in database
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: message, completion: { [weak self] success in
                if success {
                    print("Message send")
                    self?.isNewConversation = false
                } else {
                    print("failed to send")
                }
            })
        } else {
            guard let conversationId = conversationId, let name = self.title else{
                return
            }
            // Append to existing conversation data
            DatabaseManager.shared.sendMessage(to: conversationId, name: name, newMessage: message, completion: { success in
                if success{
                    print("Message sent")
                }else{
                    print("Failed to send")
                }
            })
        }
    }

    private func createMessageId() -> String? {
        // date, otherUserEmail, senderEmail, randomInt
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        
        let safeCurrentEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)
        let dateString = Self.dateFormatter.string(from: Date())

        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateString)"
        print("Created message ID: \(newIdentifier)")

        return newIdentifier
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }

        fatalError("Self Sender is nil, email should be cached")
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}
