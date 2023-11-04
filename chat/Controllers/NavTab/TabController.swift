//
//  TabController.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 29/10/23.
//

import Foundation
import UIKit

class TabController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()

        /* self.tabBar.barTintColor = .red
         self.tabBar.tintColor = .green
         self.tabBar.unselectedItemTintColor = .purple */
        self.tabBar.backgroundColor = UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        //self.tabBar.isTranslucent = true
        // self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Tab Setup

    private func setUpTabs() {
        let home = createNav(with: "Chat", and: UIImage(systemName: "ellipsis.message"), vc: ConversationsViewController())
        home.navigationBar.prefersLargeTitles = true

        let profile = createNav(with: "Profile", and: UIImage(systemName: "person.crop.circle"), vc: ProfileViewController())
        profile.navigationBar.prefersLargeTitles = true

        setViewControllers([home, profile], animated: true)
    }

    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)

        nav.tabBarItem.title = title
        nav.tabBarItem.image = image

        nav.viewControllers.first?.navigationItem.title = title

        return nav
    }
}
