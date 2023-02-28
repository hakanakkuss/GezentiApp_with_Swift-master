//
//  UIColor+Ext.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 25.01.2023.
//

import UIKit

extension UIColor {
    
    fileprivate static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    static var orange: UIColor {
        return rgb(red: 230, green: 130, blue: 91, alpha: 1)
        
    }
    static var softOrange: UIColor {
        return rgb(red: 255, green: 178, blue: 107, alpha: 1)
        
    }
    static var softYellow: UIColor {
        return rgb(red: 255, green: 213, blue: 111, alpha: 1)
       
    }
    static var softGreen: UIColor {
        return rgb(red: 147, green: 155, blue: 98, alpha: 1)
        
    }
    static var darkGreen: UIColor {
        return rgb(red:3,green:64,blue:40, alpha: 1)
    }
    
  
}

extension UIView {
    func addBackground(imageName: String) {
        let backgroundImage = UIImage(named: imageName)
        let backgroundImageView = UIImageView(frame: self.bounds)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        self.insertSubview(backgroundImageView, at: 0)
    }
}

