//
//  PlacesTableViewCell.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 17.01.2023.
//

import UIKit
import CoreData

protocol PlacesTableViewCellProtocol: AnyObject {
    func didTapFavoriteButton(word: String)
}

class PlacesTableViewCell: UITableViewCell {
    
    
    weak var delegate: PlacesTableViewCellProtocol?
    
    @IBOutlet weak var favoriteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func favoriteButtonClicked(_ sender: Any) {
        
        delegate?.didTapFavoriteButton(word: (self.textLabel?.text)!)
        
        
        
        if favoriteButton.tag == 0 {
            favoriteButton.tintColor = UIColor.brownCoffee
            favoriteButton.tag += 1
            
            
        }else {
            favoriteButton.tintColor = UIColor.almond
            favoriteButton.tag -= 1
        }
    }
    
    
    
}
