//
//  RootViewController.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class RootViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let listProjectsViewController = ListProjectsCollectionViewController.instantiate()

        setViewControllers([listProjectsViewController], animated: false)
    }

}
