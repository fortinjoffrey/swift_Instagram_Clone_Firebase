//
//  CommentInputAccessoryView.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 08/08/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import UIKit

class CommentInputAccessoryView: UIView {
    
    fileprivate let commentTextView: CommentInputTextView = {
        let tv = CommentInputTextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    }()
    
    fileprivate let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSubmit() {
        print("Handling submit comment")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        backgroundColor = .white
        
        addSubview(submitButton)
        submitButton.anchor(top: topAnchor, left: nil, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 12, width: 50, height: 0)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, topPadding: 8, leftPadding: 8, bottomPadding: 8, rightPadding: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}
