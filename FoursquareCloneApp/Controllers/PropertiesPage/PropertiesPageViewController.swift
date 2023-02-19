//
//  PropertiesPageViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 17.01.2023.
//

import UIKit
import PhotosUI
import Lottie

class PropertiesPageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,PHPickerViewControllerDelegate {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var placeNameTF: UITextField!
    @IBOutlet weak var placeTypeTF: UITextField!
    @IBOutlet weak var placeDescriptionTF: UITextField!
    @IBOutlet weak var choosePhotos: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    private var LottieAnimationView : AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseImageMethod()
        
        LottieAnimationView = .init(name: "5559-travel-app-onboarding-animation")
        LottieAnimationView!.frame = view.bounds
        LottieAnimationView!.contentMode = .scaleAspectFit
        LottieAnimationView!.loopMode = .loop
        LottieAnimationView!.animationSpeed = 0.5
        LottieAnimationView!.frame = CGRect(x: 86, y: 80, width: 210, height: 210)
        LottieAnimationView?.sizeToFit()
        view.addSubview(LottieAnimationView!)
        LottieAnimationView!.play()
        nextButton.titleLabel?.textColor = UIColor.brownCoffee
        choosePhotos.tintColor = UIColor.almond
  
      

    }
    
    func chooseImageMethod(){
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    @objc func chooseImage() {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
            
        }
   
   

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        ///Boş bir dizi tuttuk ve içine seçilen görselleri append yöntemi ile gönderdik.
        var dizi:[UIImage]=[]
        picker.dismiss(animated: true, completion: nil)
            for result in results {
                result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                    if let image = object as? UIImage {
                        dizi.append(image)
                        DispatchQueue.main.async {
                            self.imageView.image = dizi.first
                            self.imageView.layer.cornerRadius = 20
                            self.view.setNeedsLayout()
                        }
                    }
                })
            }
    }
   
    
    @objc func pickPhoto(){
        
        ///Kullanıcıya galeriden fotoğraf seçtirmek için bu fonksiyon kullanıldı.
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = PHPickerFilter.images
            
            let pickerViewController = PHPickerViewController(configuration: config)
            pickerViewController.delegate = self
            self.present(pickerViewController, animated: true, completion: nil)
        }
    
    @IBAction func choosePhotosButton(_ sender: Any) {
        pickPhoto()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imageView.image = info[.originalImage] as? UIImage
            self.dismiss(animated: true, completion: nil)
        }
    
    @IBAction func nextButton(_ sender: Any) {
        let placeModel = PlaceSingletonModel.sharedInstance
        nextButton.titleLabel?.font = UIFont.avenir(.Medium, size: 27)
        nextButton.titleLabel?.textColor = UIColor.brownCoffee
        
        if placeNameTF.text != "" && placeTypeTF.text != "" && placeDescriptionTF.text != "" {
            if let chosenImage = imageView.image  {
                
                    placeModel.placeName = placeNameTF.text!
                    placeModel.placeType = placeTypeTF.text!
                    placeModel.placeDescription = placeDescriptionTF.text!
                    placeModel.placeImage = chosenImage
            }
        }else {
           makeAlert(titleInput: "Uyarı!", messageInput: "Tüm alanları doldurduğunuzdan emin olun.")
        }
        performSegue(withIdentifier: "goToDatePage", sender: nil)
    }
}
