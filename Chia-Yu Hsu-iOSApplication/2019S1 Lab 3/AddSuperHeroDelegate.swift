//
//  AddSuperHeroDelegate.swift
//  2019S1 Lab 3
//
//  Created by Michael Wybrow on 15/3/19.
//  Copyright © 2019 Michael Wybrow. All rights reserved.
//

import Foundation
import MapKit

protocol AddSuperHeroDelegate {
    func addSuperHero(newHero: SuperHero) -> Bool
}
