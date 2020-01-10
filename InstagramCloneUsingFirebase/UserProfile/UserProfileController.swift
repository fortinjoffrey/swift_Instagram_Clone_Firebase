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

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .red
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "headerId")
        fetchUser()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
            
        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    fileprivate func fetchUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String:Any] else { return }
            
            self.user = User(dictionary: dictionary)
            let profileImageUrl = self.user?.profileImageUrl
            
            self.navigationItem.title = self.user?.username
            
            // will call again viewForSupplementaryElemntOfKind
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to observe ")
        }
    }
}

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String:Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
