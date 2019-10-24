//
//  SightDetailViewController.swift
//  2019S1 Lab 3
//
//  Created by ggguest on 2019/8/30.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit
import CoreData

class SightDetailViewController: UIViewController, DatabaseListener {
    
    var detailhero: SuperHero?
    weak var databaseController: DatabaseProtocol?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var iconImg: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
   
        if detailhero != nil{
            nameLabel.text = detailhero!.name!
            locationLabel.text = "lat: \(String(detailhero!.latitude)) long: \(String(detailhero!.longitude))"
            descLabel.text = detailhero!.abilities!
        
            photoImg.image = UIImage(data: detailhero!.photo! as Data)
            iconImg.image = UIImage(data: detailhero!.icon! as Data)
            
        }

    }
    
    var listenerType = ListenerType.heroes

    func onHeroListChange(change: DatabaseChange, heroes: [SuperHero]) {
        //not using
    }
    
    
    @IBAction func deleteHero(_ sender: Any) {
        databaseController?.deleteSuperHero(hero: detailhero!)
        navigationController?.popViewController(animated: true)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editSegue"{
            let destination = segue.destination as! EditViewController
            destination.edithero = detailhero!
            
        }
     }
    
    
}
