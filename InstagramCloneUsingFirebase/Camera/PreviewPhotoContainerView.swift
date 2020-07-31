//
//  PreviewPhotoContainerView.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 31/07/2020.
//  Copyright © 2020 Joffrey Fortin. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "save_shadow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleCancel() {
        self.removeFromSuperview()
    }
    
    @objc fileprivate func handleSave() {
        guard let previewImage = previewImageView.image else { return }
        
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
            
        }) { (success, err) in
            if let err = err {
                print("Failed to save image to photo library: ", err)
                return
            }
            
            print("Successfully saved image to photo library")
            
            DispatchQueue.main.async {
                let savedLabel = UILabel()
                savedLabel.text = "Saved successfully"
                savedLabel.textColor = .white
                savedLabel.textAlignment = .center
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.numberOfLines = 0
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                
                self.addSubview(savedLabel)
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.center
                
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    
                }) { (completed) in
                    
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                        
                    }) { (_) in
                        savedLabel.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        addSubview(previewImageView)
        previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topPadding: 0, leftPadding: 0, bottomPadding: 0, rightPadding: 0, width: 0, height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topPadding: 24, leftPadding: 24, bottomPadding: 0, rightPadding: 0, width: 50, height: 50)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topPadding: 0, leftPadding: 24, bottomPadding: 24, rightPadding: 0, width: 50, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
