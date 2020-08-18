//
//  Comment.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 18/08/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import Foundation

struct Comment {
    
    let user: User
    
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
