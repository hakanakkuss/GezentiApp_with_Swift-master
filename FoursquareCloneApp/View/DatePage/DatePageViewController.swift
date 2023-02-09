//
//  DatePageViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 4.02.2023.
//

import UIKit
import Lottie


class DatePageViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePageLabel: UILabel!
    private var LottieAnimationView : AnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LottieAnimationView = .init(name: "66346-marking-a-calendar")
        LottieAnimationView!.frame = view.bounds
        LottieAnimationView!.contentMode = .scaleAspectFit
        LottieAnimationView!.loopMode = .loop
        LottieAnimationView!.animationSpeed = 0.5
        LottieAnimationView!.frame = CGRect(x: 49, y: 80, width: 270, height: 270)
        LottieAnimationView?.sizeToFit()
        view.addSubview(LottieAnimationView!)
        LottieAnimationView!.play()
        
        

        
    }
    
    @IBAction func dateSelectedFromDatePicker(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        datePageLabel.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func saveAndForwardBtn(_ sender: Any) {
        let placeModel = PlaceSingletonModel.sharedInstance
        placeModel.placeDate = datePageLabel.text!
//        let date = datePageLabel.text
//        UserDefaults.standard.set(date, forKey: "savedLocation")
        performSegue(withIdentifier: "goToMapPage", sender: nil)
        
    }
}

