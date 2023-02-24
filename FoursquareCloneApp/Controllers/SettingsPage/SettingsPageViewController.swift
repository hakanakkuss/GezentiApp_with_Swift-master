//
//  SettingsPageViewController.swift
//  FoursquareCloneApp
//
//  Created by Macbook Pro on 5.02.2023.
//

import UIKit

class SettingsPageViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var settingsArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getSettings()
        
    }
    
    func getSettings(){
        settingsArray.append("Account")
        settingsArray.append("Notifications")
        settingsArray.append("Privacy & Security")
        settingsArray.append("Help and Support")
        settingsArray.append("About")
    }
    
}

extension SettingsPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settingsArray[indexPath.row]
        cell.textLabel?.font = UIFont.avenir(.Medium, size: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
}
