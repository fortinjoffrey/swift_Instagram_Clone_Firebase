//
//  Post.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 28/07/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import Foundation

struct Post {
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
