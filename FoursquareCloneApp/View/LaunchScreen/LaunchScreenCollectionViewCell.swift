//
//  LaunchScreenCollectionViewCell.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 3.02.2023.
//

import UIKit

class LaunchScreenCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var slideImageView: UIImageView!
    
    @IBOutlet weak var slideDescription: UILabel!
    @IBOutlet weak var slideTitle: UILabel!
    
    func setup(_ slide: OnboardingSlides) {
//        slideImageView.image = slide.image
        slideTitle.text = slide.title
        slideDescription.text = slide.description
    }
}
