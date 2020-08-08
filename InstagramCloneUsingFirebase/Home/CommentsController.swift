//
//  CommentsController.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 31/07/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .blue
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("willAppear called")
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
}
