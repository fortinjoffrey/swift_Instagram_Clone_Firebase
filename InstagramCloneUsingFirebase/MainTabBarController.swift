//
//  MainTabBarController.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 23/12/2019.
//  Copyright © 2019 Joffrey Fortin. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    if Auth.auth().currentUser == nil {
      DispatchQueue.main.async {
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
      }
      return
    }
    
    setupViewControllers()
  }
    
    func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")?.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.image = UIImage(named: "profile_unselected")?.withRenderingMode(.alwaysOriginal)
        
        tabBar.tintColor = .black
        viewControllers = [navController, UIViewController()]
    }
    
    
}
