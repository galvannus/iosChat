//
//  ChatViewController+Delegates.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 15/11/23.
//

import InputBarAccessoryView
import MessageKit
import UIKit
import SDWebImage

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
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: title ?? "User", firstMessage: message, completion: { [weak self] success in
                if success {
                    print("Message send")
                    self?.isNewConversation = false
                } else {
                    print("failed to send")
                }
            })
        } else {
            guard let conversationId = conversationId, let name = title else {
                return
            }
            // Append to existing conversation data
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: message, completion: { success in
                if success {
                    print("Message sent")
                } else {
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
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else{
            return
        }
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else{
                return
            }
            imageView.sd_setImage(with: imageUrl)
        default:
            break
        }
    }
    
    
}

extension ChatViewController: MessageCellDelegate{
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else{
            return
        }
        let message = messages[indexPath.section]
        
        switch message.kind {
        case .photo(let media):
            guard let imageUrl = media.url else{
                return
            }
            let vc = PhotoViwerViewController(with: imageUrl)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}


extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
        let imageData = image.pngData(),
        let messageId = createMessageId(),
        let conversationId = conversationId,
        let name = self.title,
        let selfSender = selfSender else{
            return
        }
        
        let fileName = "photo_message_"+messageId.replacingOccurrences(of: " ", with: "-") + ".png"
        
        //Upload image
        StorageManager.shared.uploadMessagePhoto(with: imageData, fileName: fileName, completion: { [weak self] result in
            guard let strongSelf = self else{
                return
            }
            
            switch result {
            case .success(let urlString):
                //Ready to send message
                print("Upload message photo: \(urlString)")
                
                guard let url = URL(string: urlString), let placeholder = UIImage(systemName: "plus") else{
                    return
                }
                
                let media = Media(url: url, image: nil, placeholderImage: placeholder, size: .zero)
                
                let message = Message(messageId: messageId, sentDate: Date(), kind: .photo(media), sender: selfSender)
                
                DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: strongSelf.otherUserEmail, name: name, newMessage: message,
                                                   completion: { success in
                    if success{
                        print("Sent photo message")
                    }else{
                        print("Failed to send photo message")
                    }
                })
            case .failure(let error):
                print("Message photo upload error: \(error)")
            }
        })
        //Send message
    }
}
