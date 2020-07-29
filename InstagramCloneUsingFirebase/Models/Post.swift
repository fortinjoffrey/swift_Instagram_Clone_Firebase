//
//  Post.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 28/07/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import Foundation

struct Post {
    let user: User
    let imageUrl: String
    let caption: String
    
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
