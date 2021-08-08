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

struct LonLat: Hashable {
    let lat: Double?
    let lon: Double?
    
    init(_ lat: Double?, _ lon: Double?) {
        self.lat = lat
        self.lon = lon
    }
}
struct FullUser: Codable {
    let email: String
    let password: String
    let userDetails: UserDetails
}
struct UserDetails: Codable {
    var firstName: String?
    var lastName: String?
    var latitude: Double?
    var longitude: Double?
    var birthday: String?
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
    var dateBirthday: Date? {
        guard let birthday = birthday else {
            return nil
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        return dateFormatterGet.date(from: birthday)
    }
    
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
