//
//  User.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 29/07/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import Foundation

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String:Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
