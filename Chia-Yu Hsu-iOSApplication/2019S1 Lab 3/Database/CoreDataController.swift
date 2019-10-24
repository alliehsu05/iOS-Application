//
//  CoreDataController.swift
//  2019S1 Lab 3
//
//  Created by jinrui zhang on 22/8/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {

    
    
    let DEFAULT_TEAM_NAME = "Default Team"
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistantContainer: NSPersistentContainer
    var allHeroesFetchedResultsController: NSFetchedResultsController<SuperHero>?
    var teamHeroesFetchedResultsController: NSFetchedResultsController<SuperHero>?
    
    override init() {
        persistantContainer = NSPersistentContainer(name: "Week04-SuperHeroes")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data Stack: \(error)")
            }
        }

        super.init()
        
        if fetchAllHeroes().count == 0 {
            createDefaultEntries()
        }
    }
    //save any change for database
    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    //adding to core data
    func addSuperHero(name: String, abilities: String, latitude: Double, longitude: Double, photo: NSData, icon: NSData) -> SuperHero{
        let hero = NSEntityDescription.insertNewObject(forEntityName: "SuperHero", into: persistantContainer.viewContext) as! SuperHero
        hero.name = name
        hero.abilities = abilities
        hero.latitude = latitude
        hero.longitude = longitude
        hero.photo = photo
        hero.icon = icon
        
        saveContext()
        return hero
    }

    
    func deleteSuperHero(hero: SuperHero) {
        persistantContainer.viewContext.delete(hero)
        
        saveContext()
    }

    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)

        if listener.listenerType == ListenerType.heroes {
            listener.onHeroListChange(change: .update, heroes: fetchAllHeroes())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func fetchAllHeroes() -> [SuperHero] {
        if allHeroesFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<SuperHero> = SuperHero.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            allHeroesFetchedResultsController = NSFetchedResultsController<SuperHero>(fetchRequest: fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allHeroesFetchedResultsController?.delegate = self
            
            do {
                try allHeroesFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        
        var heroes = [SuperHero]()
        if allHeroesFetchedResultsController?.fetchedObjects != nil {
            heroes = (allHeroesFetchedResultsController?.fetchedObjects)!
        }
        
        return heroes
    }

    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allHeroesFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == ListenerType.heroes {
                    listener.onHeroListChange(change:.update, heroes: fetchAllHeroes())
                }
            }
        }

    }

    
    func createDefaultEntries() {
        
        var img = UIImage(named: "flinder")!
        var imageData = img.pngData()! as NSData
        var icon = UIImage(named: "a")!
        var iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "Flinders Street Station", abilities: "Stand beneath the clocks of Melbourne's iconic railway station, as tourists and Melburnians have done for generations. Take a train for outer-Melbourne explorations, join a tour to learn more about the history of the grand building, or go underneath the station to see the changing exhibitions that line Campbell Arcade", latitude: -37.8183, longitude: 144.9671, photo: imageData, icon: iconData)
        
        img = UIImage(named: "paulcathedral")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "b")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "St Paul's Cathedral", abilities: "Leave the bustling Flinders Street Station intersection behind and enter the peaceful place of worship that's been at the heart of city life since the mid 1800s. Join a tour and admire the magnificent organ, the Persian Tile and the Five Pointed Star of the historic St Paul's Cathedral", latitude: -37.8170, longitude: 144.9677, photo: imageData, icon: iconData)
        
        img = UIImage(named: "scotschurch")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "c")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "The Scots' Church", abilities: "Look up to admire the 120-foot spire of the historic Scots' Church, once the highest point of the city skyline. Nestled between modern buildings on Russell and Collins streets, the decorated Gothic architecture and stonework is an impressive sight, as is the interior's timber panelling and stained glass. Trivia buffs, take note: the church was built by David Mitchell, father of Dame Nellie Melba (once a church chorister)", latitude: -37.8146, longitude: 144.9685, photo: imageData, icon: iconData)
        
        img = UIImage(named: "patricks")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "a")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "St Patrick's Cathedral", abilities: "Approach the mother church of the Catholic Archdiocese of Melbourne from the impressive Pilgrim Path, absorbing the tranquil sounds of running water and spiritual quotes before seeking sanctuary beneath the gargoyles and spires. Admire the splendid sacristy and chapels within, as well as the floor mosaics and brass items", latitude: -37.8101, longitude: 144.9764, photo: imageData, icon: iconData)
        
        img = UIImage(named: "shrine")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "b")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "Shrine of Remembrance", abilities: "The Shrine of Remembrance is a building with a soul. Opened in 1934, the Shrine is the Victorian state memorial to Australians who served in global conflicts throughout our nation’s history. Inspired by Classical architecture, the Shrine was designed and built by veterans of the First World War", latitude: -37.8305, longitude: 144.9734, photo: imageData, icon: iconData)
        
        img = UIImage(named: "royalexhibition")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "c")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "Royal Exhibition Building", abilities: "The building is one of the world's oldest remaining exhibition pavilions and was originally built for the Great Exhibition of 1880. Later it housed the first Commonwealth Parliament from 1901, and was the first building in Australia to achieve a World Heritage listing in 2004", latitude: -37.8047, longitude: 144.9717, photo: imageData, icon: iconData)
        
        img = UIImage(named: "cooks")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "a")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "Cooks' Cottage", abilities: "Built in 1755, Cooks' Cottage is the oldest building in Australia and a popular Melbourne tourist attraction.Originally located in Yorkshire, England, and built by the parents of Captain James Cook, the cottage was brought to Melbourne by Sir Russell Grimwade in 1934. Astonishingly, each brick was individually numbered, packed into barrels and then shipped to Australia", latitude: -37.8145, longitude: 144.9794, photo: imageData, icon: iconData)
        
        img = UIImage(named: "michael")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "b")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "St Michael's Uniting Church", abilities: "St Michael's is a unique church in the heart of the city. It is not only unique for its relevant, contemporary preaching, but for its unusual architecture.St Michael's strives to be the best possible model of what the New Faith can be; they want to attract and sustain larger numbers of people who see that this expression of church life is the most meaningful and worthwhile experience for them", latitude: -37.8143, longitude: 144.9692, photo: imageData, icon: iconData)
        
        img = UIImage(named: "altona")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "c")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "Altona Homestead", abilities: "Built in the mid-1840s by Alfred and Sarah Langhorne, Altona Homestead was the first homestead built on the foreshore of Port Phillip Bay. Remaining a private residence until 1920, the homestead changed ownership a number of times and served as a seaside holiday village, Council offices, meeting place for community groups and even a dentist", latitude: -37.8694, longitude: 144.8270, photo: imageData, icon: iconData)
        
        img = UIImage(named: "blackrock")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "a")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "Black Rock House", abilities: "Black Rock House was built in 1856 by Victoria's first Auditor-General, Charles Hotson Ebden as his seaside retreat. Complete with a castle wall and Moreton Bay Figs, this historic home in the Melbourne Bayside suburb of Black Rock has a fascinating past", latitude: -37.9783, longitude: 145.0185, photo: imageData, icon: iconData)
        
        img = UIImage(named: "labassa")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "b")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "Labassa Mansion", abilities: "Labassa is one of Australia's most outstanding 19th century mansions.Designed by architect John Augustus Bernard Koch for millionaire Alexander Robertson, the house is a thirty-five roomed property with ornate interiors in the French Second Empire style", latitude: -37.8697, longitude: 145.0076, photo: imageData, icon: iconData)
        
        img = UIImage(named: "trades")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "c")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "Trades Hall", abilities: "Established in 1859 as a meeting hall and a place to educate workers and their families - Trades Hall is still home to trade unions and political events - but has grown to embrace a diverse cultural focus. It's now a regular venue for theatre, art exhibitions, Melbourne International Comedy Festival and Melbourne Fringe Festival", latitude: -37.8064, longitude: 144.9664, photo: imageData, icon: iconData)
        
        img = UIImage(named: "theforum")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "a")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "The Forum", abilities: "Catch local stars and international artists at one of the country's most spectacular venues. The Forum's impressive neo-gothic facade (complete with gargoyles) and ornate interior design add an enchanting edge to any gig. Hear blues, country, indie and rock acts, and catch theatre and comedy under the beautiful blue sky ceiling", latitude: -37.8165, longitude: 144.9694, photo: imageData, icon: iconData)
        
        img = UIImage(named: "oldmelbourne")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "b")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "Old Melbourne Gaol", abilities: "Step back in time to Melbourne’s most feared destination since 1845, Old Melbourne Gaol.Shrouded in secrets, wander the same cells and halls as some of history’s most notorious criminals, from Ned Kelly to Squizzy Taylor, and discover the stories that never left. Hosting day and night tours, exclusive events and kids activities throughout school holidays and an immersive lock-up experience in the infamous City Watch House, the Gaol remains Melbourne’s most spell-binding journey into its past", latitude: -37.8078, longitude: 144.9653, photo: imageData, icon: iconData)
        
        img = UIImage(named: "latrobe")!
        imageData = img.pngData()! as NSData
        icon = UIImage(named: "c")!
        iconData = icon.pngData()! as NSData
        let _ = addSuperHero(name: "La Trobe's Cottage", abilities: "La Trobe's Cottage was the original home of Victoria's first Lt. Governor, Charles Joseph La Trobe, from 1839 to 1854.Described by a visitor in 1852 as 'small but elegantly furnished and standing in spacious grounds', La Trobe’s Cottage is now a vital part of Victoria’s history. The cottage was made from prefabricated materials brought from England to be the home of La Trobe, his wife Sophie and their children", latitude: -37.8316, longitude: 144.9671, photo: imageData, icon: iconData)
    }
}
