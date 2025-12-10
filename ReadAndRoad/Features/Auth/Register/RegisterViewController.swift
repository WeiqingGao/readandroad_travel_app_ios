//
//  RegisterViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

/// Controller for handling user sign-up logic and UI events.
class RegisterViewController: UIViewController {

    let registerView = RegisterView()

    override func loadView() {
        view = registerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        setupActions()
        setupNotificationObservers()
    }
}
