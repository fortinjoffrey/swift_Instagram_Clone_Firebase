//
//  FirebaseUtils.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 29/07/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension Database {
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value
            , with: { (snapshot) in
                
                guard let userDictionary = snapshot.value as? [String: Any] else { return }
                
                let user = User(uid: uid, dictionary: userDictionary)
                
                completion(user)
                
        }) { (err) in
            print("Failed to fetch user for posts: ", err)
        }
    }
}
