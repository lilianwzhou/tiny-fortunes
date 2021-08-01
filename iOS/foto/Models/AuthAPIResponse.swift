//
//  AuthAPIResponse.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-26.
//

import Foundation

struct AuthAPIResponse: Codable {
    let accessToken: String
    let userID: String

}
