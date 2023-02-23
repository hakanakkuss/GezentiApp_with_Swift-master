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

    }

    // MARK: -FETCH DATAS FROM COREDATA
    func fetchItems(){
        self.favoritesArray.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")

        do{
            let fetchResult = try managedContext.fetch(fetchRequest)

            for item in fetchResult as! [NSManagedObject]{
                self.favoritesArray.append(item.value(forKey: "item") as! String)
            }
            print(self.favoritesArray)
        }catch {
            print(error.localizedDescription)
        }
    }
    // MARK: -DELETE DATA FROM COREDATA
    func deleteItems(word: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext

        // Silmek istediğiniz verilerin bulunduğu sorguyu hazırlayın
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        fetchRequest.predicate = NSPredicate(format: "item = %@", word)

        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                managedContext.delete(data)
            }
            
            // Değişiklikleri kaydedin
            try managedContext.save()
            
        } catch let error as NSError {
            print("Core Data'dan veri silme hatası: \(error), \(error.userInfo)")
        }
    }
    
    
}


// MARK: -TABLEVIEW OPERATIONS
extension FavoritesPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = favoritesArray[indexPath.row]
        return cell

    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        
            self.favoritesArray.remove(at: indexPath.row)
            self.favoritesTableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteItems(word: String(indexPath.row))
            fetchItems()

        }
        
        
    }
}




