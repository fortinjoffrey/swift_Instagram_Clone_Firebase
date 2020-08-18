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

class CommentsController: UICollectionViewController, CommentInputAccessoryViewDelegate {
   
    
    
    var post: Post?
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
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
