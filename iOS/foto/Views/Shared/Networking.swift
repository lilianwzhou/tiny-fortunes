//
//  Networking.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-25.
//

import Foundation

struct Networking {
    static private let baseURL = "http://localhost:3000"
    
    
    static func getRequestFor(route: Route, method: RequestType) -> URLRequest? {
        let finalURL = baseURL + "/" + route.rawValue
        
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
        case PUT
        case GET
        case POST
        case DELETE
    }
}
