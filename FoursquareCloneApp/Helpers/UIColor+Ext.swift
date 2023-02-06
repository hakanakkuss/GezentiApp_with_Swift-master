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
    static var brownCoffee: UIColor {
        return rgb(red: 74, green: 38, blue: 50, alpha: 1)
    }
    static var rajah: UIColor {
        return rgb(red: 254, green: 181, blue: 97, alpha: 1)
    }
    static var cinereous: UIColor {
        return rgb(red: 160, green: 137, blue: 134, alpha: 1)
    }
    static var almond: UIColor {
        return rgb(red: 234, green: 221, blue: 205, alpha: 1)
    }
}
