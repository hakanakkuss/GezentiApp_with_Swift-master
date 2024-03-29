//
//  MapPageViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 17.01.2023.
//

import UIKit
import MapKit
import Parse

class MapPageViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, MKLocalSearchCompleterDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    var locationManager = CLLocationManager()
    var choosenPlaceLatitude = Double()
    var choosenPlaceLongitude = Double()
    var searchCompleter = MKLocalSearchCompleter()
    var searchController = UISearchController(searchResultsController: nil)
    var searchResults = [MKLocalSearchCompletion]()
    
    @IBAction func searchButton(_ sender: Any) {
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView.delegate = self
        locationManager.delegate = self
        
        searchCompleter.delegate = self
        searchBar?.delegate = self
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        searchResultsTable.layer.opacity = 0.7
        searchResultsTable.isHidden = true
        
        view.addBackground(imageName: "background1")
        
   
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.size.width, height: view.frame.size.height - view.safeAreaInsets.top)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var searchResponse = searchResults[indexPath.row]
        searchController.searchBar.text = searchResponse.title
        if searchController.searchBar.text == "" {
            searchResultsTable.isHidden = false
            searchResultsTable.reloadData()
        }else {
            searchResultsTable.isHidden = true
            searchResultsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        
        return cell
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTable.reloadData()
        
    }
    
    
    @objc func addButtonClicked() {
                
        let object = PFObject(className: "Places")
        let placeObject = PlaceSingletonModel.sharedInstance
        
        object["PlaceName"] = placeObject.placeName
        object["PlaceType"] = placeObject.placeType
        object["PlaceDescription"] = placeObject.placeDescription
        object["PlaceLatitude"] = placeObject.placeLatitude
        object["PlaceLongitude"] = placeObject.placeLongitude
        object["PlaceDate"] = placeObject.placeDate
    
        var fileArray = [PFFileObject]()
        for image in placeObject.placeImage {
            let imageData = image.jpegData(compressionQuality: 0.8)!
            imageData.base64EncodedString(options: .lineLength64Characters)
            let file = PFFileObject(data: imageData)
            fileArray.append(file!)
        }

       let imageObject = PFObject(className: "Places")
        object["imageFile"] = fileArray
        
        
        object.saveInBackground { success, error in
            if error != nil {
                let alert = UIAlertController(title: "OK", message: "HATA", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true)
                
            }else {
                self.performSegue(withIdentifier: "goToPlacesViewController", sender: nil)
            }
        }
    }
}



extension MapPageViewController {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultsTable.reloadData()
        searchBar.searchTextField.text = ""
        searchResultsTable.isHidden = true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
        searchResultsTable.isHidden = false
        if searchText != "" {
            searchResultsTable.isHidden = false
        }else {
            searchResultsTable.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response,error) in
            let latitude = response?.boundingRegion.center.latitude
            let longitude = response?.boundingRegion.center.longitude
            
            if response == nil {
                print("Error")
                
            }else {
                
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                self.mapView.addAnnotation(annotation)
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                
                PlaceSingletonModel.sharedInstance.placeLatitude = String(latitude!)
                PlaceSingletonModel.sharedInstance.placeLongitude = String(longitude!)
                
                self.searchResultsTable.isHidden = true
                
            }
            self.saveButtn()
            
        }
        
        
        
    }
    
    func saveButtn (){
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Kaydet", style: UIBarButtonItem.Style.done, target: self, action: #selector(addButtonClicked))
        self.navigationController!.navigationBar.tintColor = UIColor.orange
        
        
    }
}

extension MapPageViewController: UISearchControllerDelegate {
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchController.isActive = false
        return true
    }
}

