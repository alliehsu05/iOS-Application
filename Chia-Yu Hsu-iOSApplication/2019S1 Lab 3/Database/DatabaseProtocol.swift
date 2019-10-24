//
//  DatabaseProtocol.swift
//  2019S1 Lab 3
//
//  Created by jinrui zhang on 22/8/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case remove
    case update
}

enum ListenerType {
    case heroes
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onHeroListChange(change: DatabaseChange, heroes: [SuperHero])
}

protocol DatabaseProtocol: AnyObject {
    func addSuperHero(name: String, abilities: String, latitude: Double, longitude: Double, photo: NSData, icon: NSData) -> SuperHero
    func deleteSuperHero(hero: SuperHero)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func saveContext()
}
