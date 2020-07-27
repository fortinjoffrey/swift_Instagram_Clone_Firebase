//
//  MainTabBarController.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 23/12/2019.
//  Copyright © 2019 Joffrey Fortin. All rights reserved.
//

import UIKit
import Firebase
import Photos

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                if authStatus == .authorized {
                    DispatchQueue.main.async {
                        let layout = UICollectionViewFlowLayout()
                        let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
                        let navController = UINavigationController(rootViewController: photoSelectorController)
                        navController.modalPresentationStyle = .fullScreen
                        self.present(navController, animated: true, completion: nil)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Access denied", message: "This app does not have access to your photos or video. \nYou can enable access in Privacy Settings", preferredStyle: .actionSheet)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
            }
            return false
        }
        return true
    }
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = self
    
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
        let homeNavController = createNavController(unselectedImageName: "home_unselected", selectedImageName: "home_selected", rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let searchNavController = createNavController( unselectedImageName: "search_unselected", selectedImageName: "search_selected")
        
        let plusNavController = createNavController(unselectedImageName: "plus_unselected", selectedImageName: "plus_selected")
        
         let likeNavController = createNavController(unselectedImageName: "like_unselected", selectedImageName: "like_selected")
        
        let layout = UICollectionViewFlowLayout()
        
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem.selectedImage = UIImage(named: "profile_selected")?.withRenderingMode(.alwaysOriginal)
        userProfileNavController.tabBarItem.image = UIImage(named: "profile_unselected")?.withRenderingMode(.alwaysOriginal)
        
        tabBar.tintColor = .black
        viewControllers = [homeNavController,
                           searchNavController,
                           plusNavController,
                           likeNavController,
                           userProfileNavController]
        
        // modify tab bar items insets
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func createNavController(unselectedImageName: String, selectedImageName: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = UIImage(named: unselectedImageName)?.withRenderingMode(.alwaysOriginal)
        navController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        return navController
    }
}
