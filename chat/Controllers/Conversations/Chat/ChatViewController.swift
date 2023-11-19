//
//  ChatViewController.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 07/11/23.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        formatter.locale = .current
        return formatter
    }()
    
    public let otherUserEmail: String
    public var isNewConversation = false
    
    var messages = [Message]()
    
    var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
            return nil
        }
        
        return Sender(photoURL: "", senderId: email, displayName: "Jorge Marcial")
    }
    
    init(with email: String) {
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //messages.append(Message(messageId: "1", sentDate: Date(), kind: .text("Hello World Message"), sender: selfSender))
        //messages.append(Message(messageId: "1", sentDate: Date(), kind: .text("Hello World Message Hello World Message Hello World Message"), sender: selfSender))

        view.backgroundColor = .red

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
}


