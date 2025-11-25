//
//  MessageViewController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit
import FirebaseAuth

class MessageViewController: UIViewController {
    
    let messageView = MessageView()
    var isLoggedIn: Bool { Auth.auth().currentUser != nil }
    
    override func loadView() {
        view = messageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Messages"
        view.backgroundColor = .systemBackground
        
        messageView.isLoggedIn = isLoggedIn
        
        NotificationCenter.default.addObserver(self,
            selector: #selector(userDidLogin),
            name: .userLoggedIn,
            object: nil)
        
        messageView.buttonSignIn.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        messageView.buttonFavorites.addTarget(self, action: #selector(didTapFavorites), for: .touchUpInside)
        messageView.buttonComments.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        
        loadMessagesIfNeeded()
    }
    
    // MARK: - 加载消息数据
    func loadMessagesIfNeeded() {
        guard isLoggedIn else { return }
        // 模拟聊天数据
        messageView.chats = [
            ("Alice", "Hey, are you still in Paris?"),
            ("Bob", "Your post was awesome!"),
            ("Carol", "Let's go hiking next week."),
            ("David", "I saved your Iceland trip post!")
        ]
    }
    
    // MARK: - Actions
    @objc func didTapSignIn() {
        let signInVC = SignInViewController()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @objc func didTapFavorites() {
        let alert = UIAlertController(title: "Favorites Notifications",
                                      message: "These are the posts of yours that others have saved. (Feature coming soon)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func didTapComments() {
        let alert = UIAlertController(title: "Comments Notifications",
                                      message: "These are the comments others made on your posts. (Feature coming soon)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func userDidLogin() {
        messageView.isLoggedIn = true
        loadMessagesIfNeeded()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
