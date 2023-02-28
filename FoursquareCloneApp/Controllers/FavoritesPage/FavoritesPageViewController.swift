//
//  FavoritesPageViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 19.02.2023.
//

import UIKit
import CoreData



class FavoritesPageViewController: UIViewController {
    
    
    var favoritesArray = [String]()
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        view.addBackground(imageName: "background1")
        
    }
}


// MARK: -TABLEVIEW OPERATIONS
extension FavoritesPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favoritesArray.isEmpty {
            
            // BURAYA ANİMASYON GELECEK
            
            return 0
        } else {
            return favoritesArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = favoritesArray[indexPath.row]
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}




