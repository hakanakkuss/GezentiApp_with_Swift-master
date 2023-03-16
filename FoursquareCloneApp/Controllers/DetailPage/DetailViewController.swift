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
    @IBOutlet weak var placeDateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeType: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
    @IBOutlet weak var placeDate: UILabel!
    
    
    var choosenPlaceId = ""
    var choosenPlaceLatitude = Double()
    var choosenPlaceLongitude = Double()
    var photoArray: [UIImage] = []
    var selectedPlaceID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()
        mapView.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
      
        items()
        getImages()
        
        view.addBackground(imageName: "background1")
    }
    
    func items(){
        placeNameLabel.font = UIFont.avenir(.Medium, size: 18)
        placeTypeLabel.font = UIFont.avenir(.Medium, size: 18)
        placeDescriptionLabel.font = UIFont.avenir(.Medium, size: 18)
        placeDateLabel.font = UIFont.avenir(.Medium, size: 18)
        
        placeName.font = UIFont.avenir(.Medium, size: 20)
        placeType.font = UIFont.avenir(.Medium, size: 20)
        placeDescription.font = UIFont.avenir(.Medium, size: 20)
        placeDate.font = UIFont.avenir(.Medium, size: 20)
        
        placeName.layer.borderColor = UIColor.softGreen.cgColor
        placeName.layer.borderWidth = 1
        
        collectionView.layer.borderColor = UIColor.softYellow.cgColor
        collectionView.layer.borderWidth = 1
        collectionView.layer.cornerRadius = 10
        collectionView.backgroundColor = .none
        
    }
    
    func getImages(){
        let query = PFQuery(className:"Places")
        guard let placeId = self.selectedPlaceID else {return}
        
        query.getObjectInBackground(withId: placeId) { (objects, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let placeObject = objects {
                
                if let placeImages = placeObject["imageFile"] as? [PFFileObject] {
                    placeImages.forEach { image in
                        image.getDataInBackground { (imageData: Data?, error: Error?) in
                            if let error = error {
                                print(error.localizedDescription)
                            }else if let imageData = imageData {
                                let image = UIImage(data: imageData)
                                self.photoArray.append(image!)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func getDataFromParse () {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: self.selectedPlaceID)
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

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
  
    func scaleImage(image: UIImage, maximumSize: CGSize) -> UIImage {
        let aspectRatio = image.size.width / image.size.height
        var scaledSize = maximumSize
        if image.size.width > image.size.height {
            scaledSize.height = maximumSize.width / aspectRatio
        } else {
            scaledSize.width = maximumSize.height * aspectRatio
        }
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        let scaledImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        return scaledImage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! DetailCollectionViewCell
        cell.imagesView.image = photoArray[indexPath.item]
        let image = photoArray[indexPath.row]
        cell.imagesView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: cell.bounds.width, height: cell.bounds.height))
        cell.imagesView.contentMode = .scaleAspectFit
        cell.imagesView.clipsToBounds = true
        cell.imagesView.layer.cornerRadius = 10
        
        let scaledImage = scaleImage(image: image, maximumSize: CGSize(width: cell.bounds.width, height: cell.bounds.height))
        cell.imagesView.image = scaledImage
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height )

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 0, right: 3)
    }
}

