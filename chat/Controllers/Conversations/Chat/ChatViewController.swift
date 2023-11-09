//
//  ChatViewController.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 07/11/23.
//

import MessageKit
import UIKit

class ChatViewController: MessagesViewController {
    private var messages = [Message]()
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Jorge Marcial")

    override func viewDidLoad() {
        super.viewDidLoad()

        messages.append(Message(messageId: "1", sentDate: Date(), kind: .text("Hello World Message"), sender: selfSender))
        messages.append(Message(messageId: "1", sentDate: Date(), kind: .text("Hello World Message Hello World Message Hello World Message"), sender: selfSender))

        view.backgroundColor = .red

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> MessageKit.SenderType {
        return selfSender
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}
