//
//  NewConversationViewController.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 11/10/23.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    private var searchBar: UISearchBar!
    private var tableView: UITableView!
    private var spinner: JGProgressHUD!
    private var noResultsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setUpView()
    }
    
    private func setUpView(){
        searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users..."
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
        
        tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        noResultsLabel = UILabel()
        noResultsLabel.isHidden = true
        noResultsLabel.text = "No Results"
        noResultsLabel.textAlignment = .center
        noResultsLabel.textColor = .green
        noResultsLabel.font = .systemFont(ofSize: 21, weight: .medium)
    }
    
    @objc private func dismissSelf(){
        dismiss(animated: true, completion: nil)
    }

}

extension NewConversationViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //
    }
}
