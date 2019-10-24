//
//  AllHeroesTableViewController.swift
//  2019S1 Lab 3
//
//  Created by Michael Wybrow on 15/3/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AllHeroesTableViewController: UITableViewController, DatabaseListener, UISearchResultsUpdating, NewLocationDelegate, MKMapViewDelegate{

    let SECTION_HEROES = 0;
    let SECTION_COUNT = 1;
    let CELL_HERO = "heroCell"
    let CELL_COUNT = "totalHeroesCell"
    
    var allHeroes: [SuperHero] = []
    var filteredHeroes: [SuperHero] = []
    var superHeroDelegate: AddSuperHeroDelegate?
    weak var databaseController: DatabaseProtocol?
    var mapViewController: MapViewController?
    var locationList = [LocationAnnotation]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        filteredHeroes = allHeroes
        
        //search bar function
        let searchController = UISearchController(searchResultsController: nil);
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Heroes"
        navigationItem.searchController = searchController
        
        
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredHeroes = allHeroes.filter({(hero: SuperHero) -> Bool in
                return hero.name!.lowercased().contains(searchText)})
        }
        else {
            filteredHeroes = allHeroes;
        }
        tableView.reloadData();
    }
    
    //sorting for A-Z and Z-A
    @IBAction func sortSight(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            filteredHeroes = filteredHeroes.sorted(by: { (item1, item2) -> Bool in
                return item1.name!.lowercased().compare(item2.name!.lowercased()) == ComparisonResult.orderedAscending
            })
        }else{
            filteredHeroes = filteredHeroes.sorted(by: { (item1, item2) -> Bool in
                return item1.name!.lowercased().compare(item2.name!.lowercased()) == ComparisonResult.orderedDescending
            })
        }
        
        tableView.reloadData()
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
        updateSearchResults(for: navigationItem.searchController!)
        mapViewController?.viewWillAppear(true)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_HEROES {
            return filteredHeroes.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_HEROES {
            let heroCell = tableView.dequeueReusableCell(withIdentifier: CELL_HERO, for: indexPath) as! SuperHeroTableViewCell
            let hero = filteredHeroes[indexPath.row]
            
            heroCell.nameLabel.text = hero.name
            heroCell.abilitiesLabel.text = "lat: \(String(hero.latitude)) long: \(String(hero.longitude))"
            heroCell.iconImg.image = UIImage(data: hero.icon! as Data)
            
            return heroCell
        }
        
        let countCell = tableView.dequeueReusableCell(withIdentifier: CELL_COUNT, for: indexPath)
        countCell.textLabel?.text = "\(allHeroes.count)"
        countCell.selectionStyle = .none
        return countCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == SECTION_HEROES{
            let selectedHero = self.filteredHeroes[indexPath.row]
            let name = selectedHero.name!
            let desc = selectedHero.abilities!
            let lat = Double(selectedHero.latitude)
            let long = Double(selectedHero.longitude)
            let locationAnnotation = LocationAnnotation(newTitle: name, newSubtitle: desc, lat: lat, long: long, newphoto: selectedHero.photo!)
            
            //call function from mapviewcontroller
            mapViewController!.focusOn(annotation: locationAnnotation)
            navigationController?.popViewController(animated: true)
        }
        
    
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let selectedHero = self.filteredHeroes[indexPath.row]
        if editingStyle == .delete {
            // Delete the row from the data source
            databaseController?.deleteSuperHero(hero: selectedHero)
            
        }
        tableView.reloadData();
    }
    
    func locationAnnotationAdded(annotation: LocationAnnotation){
        locationList.append(annotation)
        mapViewController?.mapView.addAnnotation(annotation)
    }
    
}
