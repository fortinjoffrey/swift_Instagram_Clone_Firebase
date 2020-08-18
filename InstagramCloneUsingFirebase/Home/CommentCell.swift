//
//  CommentCell.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 18/08/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            let user = comment.user
            
            let attributedText = NSMutableAttributedString(string: user.username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: " " + comment.text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
            
            textView.attributedText = attributedText
            
            profileImageView.loadImage(urlString: user.profileImageUrl)
        }
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .blue
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 8, leftPadding: 8, bottomPadding: 0, rightPadding: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40/2
        
        addSubview(textView)
        textView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 4, leftPadding: 4, bottomPadding: 4, rightPadding: 4, width: 0, height: 0)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
