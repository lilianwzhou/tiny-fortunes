//
//  CreateUserAPIResponse.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-26.
//

import Foundation

struct CreateUserAPIResponse: Codable {
    let id: String
}
struct AuthAPIResponse: Codable {
    let accessToken: String
    let userID: String

}

struct FortuneAPIResponse: Codable {
    let message: String
}
