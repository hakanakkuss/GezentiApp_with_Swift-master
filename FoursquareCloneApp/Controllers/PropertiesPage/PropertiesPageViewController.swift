//
//  PropertiesPageViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 17.01.2023.
//

import UIKit
import PhotosUI
import Lottie

class PropertiesPageViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var placeNameTF: UITextField!
    @IBOutlet weak var placeTypeTF: UITextField!
    @IBOutlet weak var placeDescriptionTF: UITextField!
    @IBOutlet weak var choosePhotos: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageArray = [UIImage]()
    let lottieAnimationView = AnimationView(name: "5559-travel-app-onboarding-animation")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundView = .none
        collectionView.backgroundColor = .none
        
        lottieAnimationView.contentMode = .scaleAspectFit
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.play()
        
        view.addBackground(imageName: "background1")
        
        nextButton.titleLabel?.text = "İlerle"
        
        // Add animation view and message label to the view controller's view
        view.addSubview(lottieAnimationView)
        
        
        // Layout animation view and message label
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        choosePhotos.tintColor = UIColor.softOrange
        
        
        
        let backButton = UIBarButtonItem()
        backButton.title = "Geri"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        NSLayoutConstraint.activate([
            lottieAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lottieAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300),
            lottieAnimationView.widthAnchor.constraint(equalToConstant: 200),
            lottieAnimationView.heightAnchor.constraint(equalToConstant: 200),
            
        ])
        
    }
    

    
    @IBAction func choosePhotosButton(_ sender: Any) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 4
        
        let phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
        
        self.present(phPicker, animated: true)
    }
    
    
    
    @IBAction func nextButton(_ sender: Any) {
        let placeModel = PlaceSingletonModel.sharedInstance
        nextButton.titleLabel?.font = UIFont.avenir(.Medium, size: 27)
        nextButton.titleLabel?.textColor = UIColor.orange
        
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

extension PropertiesPageViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    self.imageArray.append(image)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
        }
    }
}


extension PropertiesPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell else {return PhotoCollectionViewCell()}
        cell.imageView.image = imageArray[indexPath.row]
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        cell.addGestureRecognizer(longPressRecognizer)
        collectionView.backgroundColor = .none
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        let image = selectedCell.imageView.image
        
        let detailVC = UIViewController()
        
        let scrollView = UIScrollView(frame: detailVC.view.bounds)
        scrollView.delegate = self
        detailVC.view.addSubview(scrollView)
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.addSubview(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        scrollView.addGestureRecognizer(tapGesture)
        scrollView.isUserInteractionEnabled = true
        
        let fullscreenView = UIView(frame: UIScreen.main.bounds)
        
        fullscreenView.alpha = 0.0
        detailVC.view.addSubview(fullscreenView)
        
        UIView.animate(withDuration: 0.9) {
            fullscreenView.alpha = 1.0
        }
        
        self.present(detailVC, animated: true, completion: nil)
        
    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLongPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // Silmek istenen hücrenin indeksini alın
            let touchPoint = gestureRecognizer.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
                // Kullanıcı onayladığı zaman hücreyi silin
                let alert = UIAlertController(title: "Silme İşlemi", message: "Bu fotoğrafı silmek istediğinize emin misiniz?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Evet", style: .destructive, handler: { (action) in
                    self.imageArray.remove(at: indexPath.item)
                    self.collectionView.deleteItems(at: [indexPath])
                })
                let noAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if collectionView.cellForItem(at: indexPath)?.isHighlighted == true {
                let alertController = UIAlertController(title: "Silmek istediğine emin misin?", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: { (_) in
                    collectionView.deleteItems(at: [indexPath])
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
            timer.invalidate()
        }
    }
    
}

extension PropertiesPageViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width / 4 , height: collectionView.frame.size.height / 2 )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        6
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        6
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
}
