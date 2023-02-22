//
//  FavoritesPageViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 19.02.2023.
//

import UIKit
import CoreData



class FavoritesPageViewController: UIViewController {
    
    
//    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        favoritesTableView.delegate = self
//        favoritesTableView.dataSource = self
        

    }

    
    
}

//extension FavoritesPageViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        cell.textLabel?.text = "hakan"
//        return cell
//
//    }
//
//    func fetchItems(){
//        self.placesArray.removeAll() //Varolan array'in içini silip core dataya ulaşıcaz.
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places") //Veritabanına istek attık.
//
//        do{
//            let fetchResult = try managedContext.fetch(fetchRequest)
//
//            for item in fetchResult as! [NSManagedObject]{
//                self.placesArray.append(item.value(forKey: "item") as! String)
//            }
//            print(self.placesArray)
//        }catch {
//            print(error.localizedDescription)
//        }
//    }
//}




