//
//  DetailViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 17.01.2023.
//

import UIKit
import MapKit
import Parse



class DetailViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeDescriptionLabel: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeDateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    var choosenPlaceId = ""
    var choosenPlaceLatitude = Double()
    var choosenPlaceLongitude = Double()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()
        mapView.delegate = self
        
        
        imageView.layer.cornerRadius = 19
    }
    
    func getDataFromParse () {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenPlaceId)
        query.findObjectsInBackground{ (objects, error) in
            if error != nil {
                print(error?.localizedDescription)
            }else {
                if objects != nil {
                    if let placeName = objects![0].object(forKey: "PlaceName") as? String {
                        self.placeNameLabel.text = placeName
                    }
                    
                    if let placeType = objects![0].object(forKey: "PlaceType") as? String {
                        self.placeTypeLabel.text = placeType
                    }
                    
                    if let placeDescription = objects![0].object(forKey: "PlaceDescription") as? String {
                        self.placeDescriptionLabel.text = placeDescription
                    }
                    
                    if let placeLatitude = objects![0].object(forKey: "PlaceLatitude") as? String {
                        if let latitude = Double(placeLatitude) {
                            self.choosenPlaceLatitude = latitude
                        }
                    }
                    
                    if let placeLongitude = objects![0].object(forKey: "PlaceLongitude") as? String {
                        if let longitude = Double(placeLongitude) {
                            self.choosenPlaceLongitude = longitude
                        }
                    }
                    
                    if let placeDate = objects![0].object(forKey: "PlaceDate") as? String {
                        self.placeDateLabel.text = placeDate
                    }
                    
                    if let placeImage = objects![0].object(forKey: "imageOne") as? PFFileObject {
                        placeImage.getDataInBackground { (data,error) in
                            if error == nil {
                                self.placeImageView.image = UIImage(data: data!)
                            }
                        }
                    }
                }
                
                let location = CLLocationCoordinate2D(latitude: self.choosenPlaceLatitude, longitude: self.choosenPlaceLongitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                let region = MKCoordinateRegion(center: location
                                                , span: span)
                self.mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = self.placeNameLabel.text
                annotation.subtitle = self.placeTypeLabel.text
                self.mapView.addAnnotation(annotation)
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        ///Burda annotation'a tıklanıldığında info tuşu çıkacak ve tıklanıldığında haritalara götürecek
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true //Pin'e tıklanıldığında sağ üst köşesinde balon çıkacak.
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }else {
            pinView?.annotation = annotation
            
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        ///Burası da baloncukta çıkan butona tıklanıldığında ne olacağına karar verdiğimiz kısım.
        if self.choosenPlaceLatitude != 0.0 && self.choosenPlaceLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.choosenPlaceLatitude, longitude: self.choosenPlaceLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let myPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: myPlaceMark)
                        mapItem.name = self.placeNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                        
                    }
                }
            }
        }
    }
    
    
}
