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

extension UserProfileController {
    func didChangeToGridView() {
        isGridViewActive = true
        collectionView.reloadData()
    }
    
    func didChangeToListView() {
        isGridViewActive = false
        collectionView.reloadData()
    }
}



class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    var user:User?
    
    var userId: String?
    
    var isGridViewActive = true
    
    var posts = [Post]()
    
    let cellId = "cellId"
    let homeFeedCellId = "homeFeedCellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: headerId)
        
        collectionView.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(HomeFeedCell.self, forCellWithReuseIdentifier: homeFeedCellId)
        
        collectionView.backgroundColor = .white
        
        setupLogOutButton()
        
        fetchUser()
    }
    
    fileprivate func setupLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc fileprivate func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            } catch let error {
                print("Failed to sign out: ", error)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    var isFinishedPaging = false
    
    fileprivate func paginatePosts() {
        
        guard let uid = user?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        
        var query = ref.queryOrderedByKey()
        
        if posts.count > 0 {
            let value = posts.last?.id
            query = query.queryStarting(atValue: value)
        }
        
        query.queryLimited(toFirst: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.posts.count > 0 {
                allObjects.removeFirst()
            }
            
            guard let user = self.user else { return }
            
            allObjects.forEach({ (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                self.posts.append(post)
            })
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to paginate for posts: ", err)
        }
    }
    
    fileprivate func fetchUser() {
        
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            // will call again viewForSupplementaryElemntOfKind
            self.collectionView.reloadData()
            
//            self.fetchOrderedPosts()
            self.paginatePosts()
        }
    }
    
    fileprivate func fetchOrderedPosts() {
        
        guard let uid = user?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let user = self.user else { return }
            
            let post = Post(user: user, dictionary: dictionary)
            
            self.posts.insert(post, at: 0)
            
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to fetch ordered posts: ", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = self.user
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == self.posts.count - 1 && !isFinishedPaging {
            paginatePosts()
        }
        
        if isGridViewActive {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
            
            cell.post = posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeFeedCellId, for: indexPath) as! HomeFeedCell
            cell.post = posts[indexPath.item]
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isGridViewActive {
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        } else {
            var height: CGFloat = 40 + 8 + 8 // header height + 2* vertical padding
            height += view.frame.width       // 1:1 ratio for post image
            height += 50                     // action buttons height
            height += 60                     // text caption height (will need to adapt in future)
            
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    // Horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // Vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
