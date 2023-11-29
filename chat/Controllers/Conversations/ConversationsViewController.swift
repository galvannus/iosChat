//
//  ConversationsViewController.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 03/10/23.
//

import FirebaseAuth
import JGProgressHUD
import UIKit

class ConversationsViewController: UIViewController {
    private var tableView: UITableView!
    var spinner: JGProgressHUD!

    var conversations = [Conversation]()
    private var loginObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        validateAuth()
        setUpView()
        setUpLayout()
        fetchConversations()
        startListeningForConversations()

        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.startListeningForConversations()
        })
    }

    private func validateAuth() {
        // let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")

        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }

    private func setUpView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ConversationsTableViewCell.self, forCellReuseIdentifier: ConversationsTableViewCell.id)
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self

        spinner = JGProgressHUD()
        spinner.style = .dark
    }

    private func setUpLayout() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func fetchConversations() {
        tableView.isHidden = false
    }

    @objc private func didTapComposeButton() {
        let vc = NewConversationViewController()
        vc.completion = { [weak self] result in
            // print("\(result)")
            guard let strongSelf = self else {
                return
            }

            // Get conversations
            let currentConversations = strongSelf.conversations
            // Get target conversation
            if let targetConversation = currentConversations.first(where: {
                $0.otherUserEmail == DatabaseManager.safeEmail(emailAddress: result.email)
            }) {
                // Open existing conversation
                let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
                vc.isNewConversation = false
                vc.title = targetConversation.name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            } else {
                strongSelf.createNewConversation(result: result)
            }
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }

    private func createNewConversation(result: SearchResult) {
        let name = result.name
        let email = DatabaseManager.safeEmail(emailAddress: result.email)

        // Check in database if conversation with these who users exists
        DatabaseManager.shared.conversationExists(with: email, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }

            switch result {
            case let .success(conversationId): // If it does, reuse conversation id
                let vc = ChatViewController(with: email, id: conversationId)
                vc.isNewConversation = false
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)

            case .failure: // Other wise use existing code
                let vc = ChatViewController(with: email, id: nil)
                vc.isNewConversation = true
                vc.title = name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }

    private func startListeningForConversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }

        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        print("Starting conversation fetch.")
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
            switch result {
            case let .success(conversations):
                print("suceesfully got conversation models")
                guard !conversations.isEmpty else {
                    return
                }

                self?.conversations = conversations

                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case let .failure(error):
                print("Failed to get conversations: \(error)")
            }
        })
    }
}
