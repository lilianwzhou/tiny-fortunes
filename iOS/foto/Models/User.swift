//
//  User.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-25.
//

import Foundation

struct User: Codable {
    let email: String
    let password: String
}

struct UserDetails: Codable {
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var birthday: Date?
    var occupation: String?
    var pineapplesOnPizza: Bool?
    var wipeStandingUp: Bool?
    var waterWet: Bool?
    var dogPerson: Bool?
    var touchGrassToday: Bool?
    var hulkFlavour: Bool?
    var earlyBird: Bool?
    var favouriteColour: String?
    var likesSushi: Bool?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case latitude
        case longitude
        case birthday
        case occupation
        case pineapplesOnPizza = "pineapples_on_pizza"
        case wipeStandingUp = "wipe_standing_up"
        case waterWet = "water_wet"
        case dogPerson = "dog_person"
        case touchGrassToday = "touch_grass_today"
        case hulkFlavour = "hulk_flavour_sour_apple"
        case earlyBird = "early_bird"
        case favouriteColour = "favourite_colour"
        case likesSushi = "likes_sushi"
    }
}
