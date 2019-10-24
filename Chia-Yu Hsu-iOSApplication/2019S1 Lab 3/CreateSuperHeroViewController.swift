//
//  CreateSuperHeroViewController.swift
//  2019S1 Lab 3
//
//  Created by Michael Wybrow on 15/3/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit
import MapKit

protocol NewLocationDelegate{
    func locationAnnotationAdded(annotation: LocationAnnotation)
}


class CreateSuperHeroViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var abilitiesTextField: UITextField!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var longTextField: UITextField!
    @IBOutlet weak var iconTextField: UITextField!
    @IBOutlet weak var imga: UIImageView!
    @IBOutlet weak var imgb: UIImageView!
    @IBOutlet weak var imgc: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    weak var databaseController: DatabaseProtocol?
    var delegate: NewLocationDelegate?
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    let icon1 = UIImage(named: "a")
    let icon2 = UIImage(named: "b")
    let icon3 = UIImage(named: "c")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

        //setting defalt icon image
        imga.image = icon1
        imgb.image = icon2
        imgc.image = icon3

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    //get passed array of location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        currentLocation = location.coordinate
    }
  
    @IBAction func useCurrentLocation(_ sender: Any) {
        if let currentLocation = currentLocation{
            latTextField.text = "\(currentLocation.latitude)"
            longTextField.text = "\(currentLocation.longitude)"
        }
        else{
            let alertController = UIAlertController(title:"Location Not Found", message: "The location has not yet been determined.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title:"Dismiss", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
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
    
    @IBAction func createHero(_ sender: Any) {
        if nameTextField.text != "" && latTextField.text != "" && longTextField.text != "" && abilitiesTextField.text != "" && iconTextField.text != ""  && imageView.image != nil{
            let name = nameTextField.text!
            let abilities = abilitiesTextField.text!
            let lat = Double(latTextField.text!)!
            let long = Double(longTextField.text!)!
            let iconNum = iconTextField.text
            let iconData: NSData
            
            if iconNum == "a" {
                iconData = icon1!.pngData()! as NSData
            }else if iconNum == "b"{
                iconData = icon2!.pngData()! as NSData
            }else{
                iconData = icon3!.pngData()! as NSData
            }

            
            let image = imageView.image
            let imageData = image!.pngData()! as NSData
            
            let _ = databaseController!.addSuperHero(name: name, abilities: abilities, latitude: lat, longitude: long, photo: imageData, icon: iconData)
            
        }else{
            //validation, show error message
            var errorMsg = "Please ensure all fields are filled:\n"
            if nameTextField.text == "" {
                errorMsg += "- Must provide a name\n"
                
            }
            if latTextField.text == "" {
                errorMsg += "- Must provide description\n"
                
            }
            if longTextField.text == "" {
                errorMsg += "- Must provide longitude\n"
                
            }
            if abilitiesTextField.text == "" {
                errorMsg += "- Must provide latitude\n"
                
            }
            if iconTextField.text == "" {
                errorMsg += "- Must choose an icon\n"
                
            }
            if imageView.image == nil {
                errorMsg += "- Must provide photo"
                
            }
            
            displayMessage(title: "Not all fields filled", message: errorMsg)
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        displayMessage(title: "There was an error in getting the image", message: "Error")
        }


}

