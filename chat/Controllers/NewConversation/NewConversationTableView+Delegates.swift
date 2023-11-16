//
//  NewConversationTableView+Delegates.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 12/11/23.
//

import Foundation
import UIKit

//Refactorizar
extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewConversationTableViewCell.id, for: indexPath) as?
        NewConversationTableViewCell else{
            fatalError("Could not cast NewConversationTableViewCell")
        }
        //cell.textLabel?.text = results[indexPath.row]["name"]
        cell.setUp(name: results[indexPath.row]["name"] ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Start Conversation
        let targetUserData = results[indexPath.row]
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
        })
        
        
    }
}
