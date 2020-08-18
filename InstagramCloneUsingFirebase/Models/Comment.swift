//
//  Comment.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 18/08/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import Foundation

struct Comment {
    let text: String
    let uid: String
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
