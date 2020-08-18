//
//  CommentsController.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 31/07/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

extension CommentsController {
    
    func didSubimt(for comment: String) {
        print("Handling submit comment")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postId = post?.id ?? ""
        
        let values = [
            "text": comment,
            "creationDate": Date().timeIntervalSince1970,
            "uid": uid
            ] as [String : Any]
        
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to insert comment: ", err)
                return
            }
            
            print("Successfully inserted comment")
        }
    }
}

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout,CommentInputAccessoryViewDelegate {
   
    
    
    var post: Post?
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .blue
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    var comments = [Comment]()
    
    fileprivate func fetchComments() {
        guard let postId = post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in

            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let comment = Comment(dictionary: dictionary)
            
            self.comments.append(comment)
            
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to observe comments: ", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        
        cell.comment = comments[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
