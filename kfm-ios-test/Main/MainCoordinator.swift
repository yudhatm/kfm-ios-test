//
//  MainCoordinator.swift
//  kfm-ios-test
//
//  Created by Yudha on 23/12/21.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = ViewController.instantiate()
        vc.viewModel = MainViewModel()
        navigationController.pushViewController(vc, animated: false)
    }
}
