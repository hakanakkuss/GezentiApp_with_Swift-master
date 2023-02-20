//
//  PlacesViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 17.01.2023.
//

import UIKit
import Parse

class PlacesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
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
                    print("silindi")
            }
        }
    }
}

extension PlacesViewController: PlacesTableViewCellProtocol {
    func didTapFavoriteButton() {
        print("helo")
        performSegue(withIdentifier: "goToFavoritesPage", sender: nil)
    }
    
    
}
