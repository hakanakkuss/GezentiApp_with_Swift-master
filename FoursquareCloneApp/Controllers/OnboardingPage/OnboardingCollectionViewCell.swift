//
//  OnboardingCollectionViewCell.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 4.02.2023.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var sliderDescriptionLabel: UILabel!
    @IBOutlet weak var sliderImageView: UIImageView!
    
    
    func setup(_ slide: OnboardingSlider) {
        sliderImageView.image = slide.sliderImage
        sliderLabel.text = slide.title
        sliderLabel.textColor = .orange
        sliderLabel.font = UIFont.avenir(.Medium, size: 22)
        sliderLabel.layer.zPosition = 1
        sliderDescriptionLabel.text = slide.description
        sliderDescriptionLabel.textColor = .darkGreen
        sliderDescriptionLabel.lineBreakMode = .byWordWrapping
        
        sliderDescriptionLabel.font = UIFont.avenir(.Medium, size: 10)
        
    
        
        
    }
    
}
