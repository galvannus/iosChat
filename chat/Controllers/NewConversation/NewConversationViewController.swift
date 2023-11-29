//
//  NewConversationViewController.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 11/10/23.
//

import JGProgressHUD
import UIKit

class NewConversationViewController: UIViewController {
    private var searchBar: UISearchBar!
    private var tableView: UITableView!
    private var spinner: JGProgressHUD!
    private var noResultsLabel: UILabel!
    private var users = [[String: String]]()
    var results = [SearchResult]()
    private var hasFetched = false
    public var completion: ((SearchResult) -> (Void))?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setUpView()
        setUpLayout()
    }

    private func setUpView() {
        
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users..."
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()

        tableView = UITableView()
        tableView.isHidden = true
        tableView.register(NewConversationTableViewCell.self, forCellReuseIdentifier: NewConversationTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self

        noResultsLabel = UILabel()
        noResultsLabel.isHidden = true
        noResultsLabel.text = "No Results"
        //noResultsLabel.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        noResultsLabel.textAlignment = .center
        noResultsLabel.textColor = .green
        noResultsLabel.font = .systemFont(ofSize: 21, weight: .medium)

        spinner = JGProgressHUD()
        spinner.style = .dark
        
        [tableView,noResultsLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func setUpLayout() {
        view.addSubview(noResultsLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            noResultsLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            //noResultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noResultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }

        searchBar.resignFirstResponder()

        results.removeAll()
        spinner.show(in: view)

        searchUsers(query: text)
    }

    func searchUsers(query: String) {
        // Check if array has firebase results
        if hasFetched {
            // If it does: filter
            filterUsers(width: query)
        } else {
            // If not, fetch then filter
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case let .success(usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(width: query)
                case let .failure(error):
                    print("Failed to get users: \(error)")
                }
            })
        }
    }

    func filterUsers(width term: String) {
        print("Filter users")
        // Update the UI: either show results or show no results label
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hasFetched else {
            return
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: currentUserEmail)

        spinner.dismiss()

        let results: [SearchResult] = users.filter({
            //Show only diffrents users
            guard let email = $0["email"], email != safeEmail else{
                return false
            }
            guard let name = $0["name"]?.lowercased() else {
                return false
            }

            return name.hasPrefix(term.lowercased())
        }).compactMap({
            guard let email = $0["email"], let name = $0["name"] else {
                return nil
            }
            return SearchResult(name: name, email: email)
        })

        self.results = results

        updateUI()
    }

    func updateUI() {
        if results.isEmpty {
            print("Is empty")
            noResultsLabel.isHidden = false
            tableView.isHidden = true
        } else {
            print("With data")
            noResultsLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}
