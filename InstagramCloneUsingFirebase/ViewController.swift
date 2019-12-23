//
//  ViewController.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 14/12/2019.
//  Copyright © 2019 Joffrey Fortin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        
//        button.imageView?.layer.masksToBounds = false
//        button.imageView?.layer.cornerRadius = button.imageView?.frame.height ?? 0
//        button.imageView?.clipsToBounds = true
//        button.imageView?.layer.borderColor = UIColor.black.cgColor
        
        
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        return tf
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        return tf
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(r: 149, g: 204, b: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(plusPhotoButton)
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, topPadding: 40, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topPadding: 20, leftPadding: 40, bottomPadding: 40, rightPadding: 40, width: 0, height: 200)
                
    }
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let err = error {
                print("Failed to create user : ", err)
                return
            }
            
            print("Successfully created user : ", result?.user.uid ?? 0)
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
                        
            storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                
                if let err = err {
                    print("Failed to upload profile image : ", err)
                    return
                }
                                                
                storageRef.downloadURL { (downloadURL, err) in
                    if let err = err {
                        print("Failed to fetch download URL : ", err)
                        return
                    }
                    
                    guard let profileImageURL = downloadURL?.absoluteString else { return }
                    
                    print("Successfully uploaded profile image : ", profileImageURL)
                    
                    
                    
                    guard let uid = result?.user.uid else { return }

                    let dicrionnaryValues = ["username":username, "profileImageUrl":profileImageURL]
                    let values = [uid:dicrionnaryValues]
                    Database.database().reference().child("users").updateChildValues(values) { (err, ref) in

                        if let err = err {
                            print("Failed to save username : ", err)
                            return
                        }

                        print("Successfully saved username")
                    }
                    
                    
                }
            }
        
        }
    }
    
    @objc func handleTextInputChanged() {
        
        let isFormValid = emailTextField.text?.count ?? 0 > 0 &&
            usernameTextField.text?.count ?? 0 > 0 &&
            passwordTextField.text?.count ?? 0 > 0
        
        signUpButton.backgroundColor = isFormValid ? UIColor.rgb(r: 17, g: 154, b: 237) :  UIColor.rgb(r: 149, g: 204, b: 244)
        signUpButton.isEnabled = isFormValid
    }
    
    @objc func handlePlusPhoto() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage, for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            plusPhotoButton.setImage(originalImage, for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
        
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
    }
}
