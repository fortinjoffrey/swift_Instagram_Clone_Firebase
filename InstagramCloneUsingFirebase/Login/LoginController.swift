//
//  LoginController.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 02/07/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Don't have an account? Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true

        view.backgroundColor = .white
        view.addSubview(signUpButton)
        signUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 50)
    }
}
