//
//  Networking.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-25.
//

import Foundation

struct Networking {
    static private let baseURL = "https://tinyfortunes-api.herokuapp.com"
    
    static var jwt: String?
    static var userID: String?
    
    static func getRequestFor(route: Route, method: RequestType, tail: String = "") -> URLRequest? {
        let finalURL = baseURL + "/" + route.rawValue + tail
        
        guard let url = URL(string: finalURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        return request
    }
    
    enum Route: String {
        case user
        case auth
        case fortune
    }
    
    enum RequestType: String {
        case PATCH
        case GET
        case POST
        case DELETE
    }
}
