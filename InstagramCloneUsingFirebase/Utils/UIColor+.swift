//
//  UIColor+.swift
//  InstagramCloneUsingFirebase
//
//  Created by Joffrey Fortin on 14/12/2019.
//  Copyright © 2019 Joffrey Fortin. All rights reserved.
//

import UIKit


extension UIColor {
    
    static let mainBlue = UIColor.rgb(r: 17, g: 154, b: 237)
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor
    {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

