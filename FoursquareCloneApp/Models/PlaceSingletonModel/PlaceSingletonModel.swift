//
//  PlaceSingletonModel.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 20.01.2023.
//

import Foundation
import UIKit

class PlaceSingletonModel {
    
    ///PlaceSingletonModel sınıfndan bir nesne oluşturuyoruz ve burda başka bir nesne oluşturulamaz.
    ///
//    var object: Any?
//    
//    func setObject(_ object: Any?) {
//        self.object = object
//    }
    static let sharedInstance = PlaceSingletonModel()
    
    var placeName = ""
    var placeType = ""
    var placeDescription = ""
    var placeImage = [UIImage]()
    var placeLatitude = ""
    var placeLongitude = ""
    var placeDate = ""
    
    private init(){} ///Başka hiç bir yerden initializing işlemi yapılamayacak anlamına gelir.
    
    
    
    
}
