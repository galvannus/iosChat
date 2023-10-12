//
//  AppCoordinator.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 03/10/23.
//

import Foundation

class AppCoordinator: Coordinator{
    var context: Context?
    init(context: Context) {
        self.context = context
    }
    func start() {
        //let viewController = ViewController()
        /*viewController.viewModel = ViewModel()
        viewController.coordinator = self
        viewController.context = context
        context?.push(viewController: viewController)*/
    }
}
