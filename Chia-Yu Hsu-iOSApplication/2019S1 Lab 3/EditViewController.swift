//
//  EditViewController.swift
//  2019S1 Lab 3
//
//  Created by Chia-Yu Hsu on 2/9/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController, DatabaseListener, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    var edithero: SuperHero?

    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var latTextView: UITextField!
    @IBOutlet weak var longTextView: UITextField!
    @IBOutlet weak var descTextView: UITextField!
    @IBOutlet weak var imga: UIImageView!
    @IBOutlet weak var imgb: UIImageView!
    @IBOutlet weak var imgc: UIImageView!
    @IBOutlet weak var iconTextView: UITextField!
    @IBOutlet weak var photoImg: UIImageView!
    
    //setting default icon image
    let icon1 = UIImage(named: "a")
    let icon2 = UIImage(named: "b")
    let icon3 = UIImage(named: "c")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        //give sight text on edit page
        if edithero != nil{
            nameTextView.text = edithero!.name!
            latTextView.text = String(edithero!.latitude)
            longTextView.text = String(edithero!.longitude)
            descTextView.text = edithero!.abilities!
            iconTextView.text = "a"
            photoImg.image = UIImage(data: edithero!.photo! as Data)
        }
        imga.image = icon1
        imgb.image = icon2
        imgc.image = icon3

    }
    
    
    var listenerType = ListenerType.heroes
    weak var databaseController: DatabaseProtocol?

    func onHeroListChange(change: DatabaseChange, heroes: [SuperHero]) {
        //not using
    }
    
    
    func displayMessage(title: String, message: String) {
        // Setup an alert to show user details about the Person
        // UIAlertController manages an alert instance
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func takePhoto(_ sender: Any) {
        let controller = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            controller.sourceType = .camera
        } else{
            controller.sourceType = .photoLibrary
        }
        
        controller.allowsEditing = false
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func updateHero(_ sender: Any) {
    
        if nameTextView.text != "" && latTextView.text != "" && longTextView.text != "" && descTextView.text != "" && iconTextView.text != "" && photoImg.image != nil{
            let name = nameTextView.text!
            let abilities = descTextView.text!
            let lat = Double(latTextView.text!)!
            let long = Double(longTextView.text!)!
            let iconNum = iconTextView.text
            let iconData: NSData
            
            if iconNum == "a" {
                iconData = icon1!.pngData()! as NSData
            }else if iconNum == "b"{
                iconData = icon2!.pngData()! as NSData
            }else{
                iconData = icon3!.pngData()! as NSData
            }
            
            let image = photoImg.image
            let imageData = image!.pngData()! as NSData
            
            
            let _ = databaseController!.addSuperHero(name: name, abilities: abilities, latitude: lat, longitude: long, photo: imageData, icon: iconData)
            
            databaseController?.deleteSuperHero(hero: edithero!)
        }else{
            //validation , show error message
            var errorMsg = "Please ensure all fields are filled:\n"
            if nameTextView.text == "" {
                errorMsg += "- Must provide a name\n"
                
            }
            if descTextView.text == "" {
                errorMsg += "- Must provide description\n"
                
            }
            if longTextView.text == "" {
                errorMsg += "- Must provide longitude\n"
                
            }
            if latTextView.text == "" {
                errorMsg += "- Must provide latitude\n"
                
            }
            if iconTextView.text == "" {
                errorMsg += "- Must choose an icon\n"
                
            }
            if photoImg.image == nil {
                errorMsg += "- Must provide photo"
                
            }
            
            displayMessage(title: "Not all fields filled", message: errorMsg)
            
        }
        
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            photoImg.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }


}
