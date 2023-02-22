//
//  PlacesViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 17.01.2023.
//

import UIKit
import Parse
import CoreData

class PlacesViewController: UIViewController {
   

    @IBOutlet weak var tableView: UITableView!
    
    var placesArray = [String]()
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()
        navigationControl()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    

    func navigationControl(){
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Çıkış Yap", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutButtonClicked))
        self.navigationController!.navigationBar.tintColor = UIColor.almond
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places") //PFQuery methoduyla "Places" isimli sınıfa ait verileri çekiyoruz.
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "error")
            }else {
                if objects != nil {
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                   
                    for object in objects! { //Gelen veriler içerisinde for döngüsü yapıp verileri gerekli yerlere basıyoruz.
                        if let placeName = object.object(forKey: "PlaceName") as? String {
                            
                            if let placeId = object.objectId {
                                self.placeNameArray.insert(placeName, at: 0)
                                self.placeIdArray.insert(placeId, at: 0)
                                                                
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.choosenPlaceId = selectedPlaceId
        }
    }
    
  
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlaceId = placeIdArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "goToPropertiesPage", sender: nil)
    }
    
    @objc func logOutButtonClicked(){
        
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(titleInput: "Hata", messageInput: error?.localizedDescription ?? "error")
            }else {
                self.performSegue(withIdentifier: "goToHomePage", sender: nil)
            }
        }
    }
    
    
}


// MARK: -TABLE VİEW OPERATIONS

extension PlacesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PlacesTableViewCell
        cell.textLabel?.text = placeNameArray[indexPath.row]
        cell.selectionStyle = .default
        cell.textLabel?.font = UIFont.avenir(.Heavy, size: 18)
        cell.textLabel?.textColor = UIColor.brownCoffee
        cell.delegate = self
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.placeNameArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)

            let query = PFQuery(className: "Places")
            query.whereKey("objectId", equalTo: placeIdArray[indexPath.row])
            query.findObjectsInBackground { placeNameArray, error in
                ((objects: [AnyObject]?, error: NSError?) -> Void).self
                      for object in placeNameArray! {
                          object.deleteEventually()
                      }
            }
        }
        
        
    }
    
    // MARK: -INSERT DATA TO COREDATA
    func createItemsCoreData(word: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        ///Veri tabanı bağlantısı
        let managedContext = appDelegate.persistentContainer.viewContext //CoreData işlemi yapacağımızı belirttik.
        let entity = NSEntityDescription.entity(forEntityName: "Places", in: managedContext)! //Entity'i çağırdık.
        let item = NSManagedObject(entity: entity, insertInto: managedContext) // Model'i çağırdık.

        item.setValue(word, forKey: "item") //Veritabanına veri kaydetme.
        placesArray.append(word)
//        print((placesArray))

        do{
            try managedContext.save() //Veritabanına veri kaydetme.

        }catch {
            print(error.localizedDescription)
        }
    }
    
     // MARK: -FETCH DATAS FROM COREDATA
    func fetchItems(){
        self.placesArray.removeAll() //Varolan array'in içini silip core dataya ulaşıcaz.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places") //Veritabanına istek attık.

        do{
            let fetchResult = try managedContext.fetch(fetchRequest)

            for item in fetchResult as! [NSManagedObject]{
                self.placesArray.append(item.value(forKey: "item") as! String)
            }

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


extension PlacesViewController: PlacesTableViewCellProtocol {

    func didTapFavoriteButton(word: String) {
//        createItemsCoreData(word: word)
        deleteItems(word: word)
        fetchItems()
    }
    

}

