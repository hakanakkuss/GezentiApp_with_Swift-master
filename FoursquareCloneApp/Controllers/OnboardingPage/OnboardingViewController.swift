//
//  OnboardingViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 4.02.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var sliderArray : [OnboardingSlider] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == sliderArray.count - 1 {
                nextButton.isHidden = false
                nextButton.setTitle("Harika! Başlayalım", for: .normal)
            } else {
                nextButton.isHidden = false
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        sliderArray = [
            OnboardingSlider(title: "Gezintiye Çık", description: "Gittiğin yerlerin adreslerini kolaylıkla kaydedebilirsin.", sliderImage: UIImage(named: "travel1")!),
            OnboardingSlider(title: "Buluşma Ayarla", description: "Sevgilinle romantik bir akşam yemeği için gittiğin yerleri kontrol edebilirsin.", sliderImage: UIImage(named: "date")!),
            OnboardingSlider(title: "Kafanı Dağıt", description: "Sebepsizce bazen kaçıp gitmeden önce ziyaret ettiğin yerlere göz atabilirsin.", sliderImage: UIImage(named: "bussiness")!)
        ]
        
        nextButton.isHidden = false
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if currentPage == sliderArray.count - 1 {
            performSegue(withIdentifier: "goToViewController", sender: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
        
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(sliderArray[indexPath.row])
        cell.sliderImageView.image = sliderArray[indexPath.row].sliderImage
        cell.sliderImageView.contentMode = .scaleAspectFit
        cell.sliderImageView.autoresizingMask = .flexibleHeight
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        
    }
    
    
    
    
}
