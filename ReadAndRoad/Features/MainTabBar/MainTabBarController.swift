//
//  MainTabBarController.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 11/10/25.
//

import UIKit
import FirebaseAuth
class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        // 各模块的主控制器
        let communityVC = ViewController()
        let navCommunity = UINavigationController(rootViewController: communityVC)
        navCommunity.tabBarItem = UITabBarItem(title: "Community",
                                               image: UIImage(systemName: "person.3"),
                                               tag: 0)
        let spotsVC = SpotsViewController()
        let navSpots = UINavigationController(rootViewController: spotsVC)
        navSpots.tabBarItem = UITabBarItem(title: "Spots",
                                           image: UIImage(systemName: "mappin.and.ellipse"),
                                           tag: 1)
        let addVC = CreatePostViewController()
        let navAdd = UINavigationController(rootViewController: addVC)
        navAdd.tabBarItem = UITabBarItem(title: "Add",
                                         image: UIImage(systemName: "plus.circle.fill"),
                                         tag: 2)
        let messageVC = MessageViewController()
        let navMessage = UINavigationController(rootViewController: messageVC)
        navMessage.tabBarItem = UITabBarItem(title: "Message",
                                             image: UIImage(systemName: "message"),
                                             tag: 3)
        let profileVC = ProfileViewController()
        let navProfile = UINavigationController(rootViewController: profileVC)
        navProfile.tabBarItem = UITabBarItem(title: "Me",
                                             image: UIImage(systemName: "person.crop.circle"),
                                             tag: 4)

        viewControllers = [navCommunity, navSpots, navAdd, navMessage, navProfile]
        selectedIndex = 0
    }
    
    private func setupAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .systemBackground
    }
    
    // MARK: - Should Select Tab
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {

        guard let nav = viewController as? UINavigationController,
              let topVC = nav.topViewController else {
            return true
        }

        // 如果点击 Add
        if topVC is CreatePostViewController {
            // 如果已经登录
            if Auth.auth().currentUser != nil {
                return true
            }
            
            // 如果未登录
            let alert = UIAlertController(
                title: "Login Required",
                message: "Please sign in to create a post.",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { _ in
                let signInVC = SignInViewController()
                
                if let currentNav = self.selectedViewController as? UINavigationController {
                    currentNav.pushViewController(signInVC, animated: true)
                }
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(alert, animated: true)

            return false
        }

        return true
    }

    
}

