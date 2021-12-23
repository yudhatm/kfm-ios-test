//
//  Coordinator.swift
//  kfm-ios-test
//
//  Created by Yudha on 23/12/21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
