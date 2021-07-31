//
//  AuthAPIResponse.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-26.
//

import Foundation

struct AuthAPIResponse: Codable {
    let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
}
