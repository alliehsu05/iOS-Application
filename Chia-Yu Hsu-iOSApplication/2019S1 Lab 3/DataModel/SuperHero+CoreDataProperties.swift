//
//  SuperHero+CoreDataProperties.swift
//  2019S1 Lab 3
//
//  Created by Chia-Yu Hsu on 1/9/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//
//

import Foundation
import CoreData


extension SuperHero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SuperHero> {
        return NSFetchRequest<SuperHero>(entityName: "SuperHero")
    }

    @NSManaged public var abilities: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var icon: NSData?
    @NSManaged public var photo: NSData?
    @NSManaged public var teams: NSSet?

}

