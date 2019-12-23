//
//  UserProfileController.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 23/12/2019.
//  Copyright © 2019 Joffrey Fortin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .green
                
        fetchUser()
    }
    
    fileprivate func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            
            guard let username = dictionary["username"] as? String else { return }
            
            self.navigationItem.title = username
        }) { (err) in
            print("Failed to observe ")
        }
    }
}
