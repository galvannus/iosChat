//
//  ProfileViewController.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 11/10/23.
//

import FirebaseAuth
import UIKit

class ProfileViewController: UIViewController {
    private var tableView: UITableView = UITableView()

    let data = ["Log Out"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray6

        setUpView()
        setUpLayout()
    }

    private func setUpView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray6
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        tableView.tableHeaderView = createTableHeader()
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

    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else{
            return nil
        }
        
        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
        let fileName = safeEmail + "_profile_picture.png"
        let path = "images/"+fileName
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 170))
        headerView.backgroundColor = .link
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.frame.size.width-150) / 2, y: 10, width: 150, height: 150))
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        
        headerView.addSubview(imageView)
        
        return headerView
    }
}

/* extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return data.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         cell.textLabel?.text = data[indexPath.row]
         cell.textLabel?.textAlignment = .center
         cell.textLabel?.textColor = .red

         return cell

         /// textLaber will be deprecated in the future ios
         /* var config = UIListContentConfiguration.cell()
          config.text = ""
          config.secondaryText = ""
          cell.contentConfiguration = config */
     }

     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)

         do {
             try FirebaseAuth.Auth.auth().signOut()

             let vc = LoginViewController()
             let nav = UINavigationController(rootViewController: vc)
             nav.modalPresentationStyle = .fullScreen
             present(nav, animated: false)
         } catch {
             print("Failed to log out.")
         }
     }
 }
 */
