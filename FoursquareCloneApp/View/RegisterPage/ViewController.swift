//
//  ViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 12.01.2023.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    @IBAction func signInClicked(_ sender: Any) {
        
        if userNameTF.text != "" && passwordTF.text != "" {
            PFUser.logInWithUsername(inBackground: userNameTF.text!, password: passwordTF.text!) { [self] user, error in
                if error != nil {
                    makeAlert(titleInput: "Error", messageInput: "Email/Password Invalid")
                }else {
                    performSegue(withIdentifier: "goToNavigationController", sender: nil)
//                    signInButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
                }
            }
        }else {
            makeAlert(titleInput: "Error", messageInput: "Email/Password Invalid")
        }
      
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if userNameTF.text != "" && passwordTF.text != "" {
            ///parse a kaydedilecek
            let info = PFUser()
            info.username = userNameTF.text
            info.password = passwordTF.text
            
            info.signUpInBackground { [self] success, error in
                if error != nil {
                    makeAlert(titleInput: "Error", messageInput: "E-mail or Password Invalid")
                }else {
                    info["Username"] = userNameTF.text
                    info["Password"] = passwordTF.text
                    
                }
            }
           
        }else {
            makeAlert(titleInput: "Error", messageInput: "E-mail or Password Invalid")
        }
    }
    
//    @objc func didTapButton() {
//            //Create and present tab bar controller
//            let tabBarVC = UITabBarController()
//            let vc1 = UINavigationController(rootViewController: PropertiesPageViewController())
//            let vc2 = UINavigationController(rootViewController: DatePageViewController())
//            let vc3 = UINavigationController(rootViewController: MapPageViewController())
//
//            vc1.title = "Home"
//            vc2.title = "Settings"
//            vc3.title = "About"
//
//            print("helo")
//
//            tabBarVC.setViewControllers([vc1,vc2,vc3], animated: false)
//
//            //tab bar itemlerimizi bir diziye atıyoruz.
//            let items = tabBarVC.tabBar.items
//
//            //Kullanacağımız ikon isimlerini de bir listeye atıyoruz.
//            let images = ["house","gear","person.circle"]
//
//            // Ardından for döngüsü yardımıyla bu itemlere ikonlarını atarken,
//            //itemlerin badgeValue sayılarını da for döngüsündeki integer değeri
//            //kullanarak örnek olması adına ekliyoruz.
//            for item in 0..<items!.count {
//                //Sekme ikonlarını atıyoruz.
//                items![item].image = UIImage(systemName: images[item])
//                //Bildirim sayısı için badgeValue değeri atıyoruz.
//                items![item].badgeValue = String(item+1)
//            }
//
//            //Tab Bar Controller'ın nasıl görüntüleneceğini belirliyoruz.
//            tabBarVC.modalPresentationStyle = .fullScreen
//            //Ardından tab bar controller'ımızı
//            present(tabBarVC,animated: true)
//    }
    
}

