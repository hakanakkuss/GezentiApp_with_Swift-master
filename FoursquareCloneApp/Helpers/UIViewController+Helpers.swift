//
//  AlertExtension.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 25.01.2023.
//

import UIKit

extension UIViewController {
    
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok!", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
