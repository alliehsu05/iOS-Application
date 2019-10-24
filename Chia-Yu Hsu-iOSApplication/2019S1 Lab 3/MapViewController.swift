//
//  MapViewController.swift
//  2019S1 Lab 3
//
//  Created by ggguest on 2019/8/30.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class MapViewController: UIViewController, DatabaseListener, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    var allHeroes: [SuperHero] = []
    var filteredHeroes: [SuperHero] = []
    weak var databaseController: DatabaseProtocol?
    var locationList = [LocationAnnotation]()
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        self.mapView.delegate = self
        filteredHeroes = allHeroes
        
        //show CBD on the map first
        let CBD = CLLocation(latitude: -37.8124, longitude: 144.9623)
        let region = MKCoordinateRegion(center: CBD.coordinate, latitudinalMeters: 7000, longitudinalMeters: 7000)
        mapView.setRegion(region, animated: true)
        
        locationManager.delegate = self
        //displays a prompt
        locationManager.requestAlwaysAuthorization()
        
       // reloadAnnotation()

    }


    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    var listenerType = ListenerType.heroes

    func onHeroListChange(change: DatabaseChange, heroes: [SuperHero]) {
        allHeroes = heroes
        
        let allAnnotations = mapView.annotations
        
        //remove all annotations
        for j in allAnnotations{
            mapView.removeAnnotation(j)
        }
        
        locationList = []
        //add updated location info
        for i in allHeroes{
            let location = LocationAnnotation(newTitle: i.name!, newSubtitle: i.abilities!, lat: i.latitude, long: i.longitude, newphoto: i.photo!)
            locationList.append(location)
            //add annotation
            mapView.addAnnotation(location)
            
            let geoLocation = CLCircularRegion(center: location.coordinate, radius: 500, identifier: location.title!)
            geoLocation.notifyOnEntry = true
            geoLocation.notifyOnExit = true
            locationManager.startMonitoring(for: geoLocation)

 
        }
        
    }


    func strartMonitoring(annotation: LocationAnnotation){
        
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            let alert = UIAlertController(title: "Error", message: "Geofencing is not supported on this device!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
           
            let message = "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location"
            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let fenceRegion = region(with: annotation)
        
        locationManager.startMonitoring(for: fenceRegion)
    }
    
    
    func stopMonitoring(annotation: LocationAnnotation){
        for region in locationManager.monitoredRegions{
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == annotation.title else{
                continue
            }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let alert = UIAlertController(title: "Movement Detected!", message: "You have left \(region.identifier)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    

    
    //check user authorization
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = (status == .authorizedAlways)
    }
    
    func region(with annotation: LocationAnnotation) -> CLCircularRegion {
        let region = CLCircularRegion(center: annotation.coordinate, radius: 100, identifier: annotation.title!)
        region.notifyOnExit = true
        region.notifyOnEntry = true
        return region
    }
    
    /* it won't show the title and description so skip the function
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let av = MKAnnotationView(annotation: annotation, reuseIdentifier: "anything")
        let iconlist = ["a","b","c"]
        let image = UIImage(named: iconlist.randomElement()!)
        av.image = image
        return av
    }*/
    
    @IBAction func centerCBD(_ sender: Any) {
        let CBD = CLLocation(latitude: -37.8124, longitude: 144.9623)
        let region = MKCoordinateRegion(center: CBD.coordinate, latitudinalMeters: 7000, longitudinalMeters: 7000)
        mapView.setRegion(region, animated: true)
    }
    
    
    func focusOn(annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
        let zoomRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000,longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(zoomRegion), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "allsightSegue"{
            let destination = segue.destination as! AllHeroesTableViewController
            //   destination.mapDelegate = self
            destination.mapViewController = self
        }
        
        //sent sight info to detailSegue
        if segue.identifier == "detailSegue"{
            let destination = segue.destination as! SightDetailViewController
            let selectedAnnotation = mapView.selectedAnnotations[0]
            var indexOfAnnotation = 0
            
            //get index of locationlist
            for i in locationList{
                if selectedAnnotation.title == i.title{
                    break
                }else{
                    indexOfAnnotation += 1
                }
            }
            //sent sight which is choosed by index
            destination.detailhero = allHeroes[indexOfAnnotation]
        }
    }
    
    
    
    
    
}
