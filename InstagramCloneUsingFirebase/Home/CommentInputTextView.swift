//
//  CommentInputTextView.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 08/08/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    fileprivate let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter comment"
        label.textColor = UIColor.lightGray
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        

        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 8, leftPadding: 8, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
    }
    
    @objc func handleTextChanged() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

