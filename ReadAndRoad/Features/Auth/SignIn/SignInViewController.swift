//
//  SignInViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit

/// Controller for handling user login actions and navigation.
class SignInViewController: UIViewController {
    
    let signInView = SignInView()
    
    override func loadView() {
        view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        setupNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "Sign In"
    }
}
