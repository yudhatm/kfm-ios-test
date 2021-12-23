//
//  BaseURL.swift
//  kfm-ios-test
//
//  Created by Yudha on 23/12/21.
//

import Foundation

class URLs {
    //Api key for weatherapi.com
    static let apiKey = "e948b64fc0b9472f9a634400212312"
    
    static let baseURL = "http://api.weatherapi.com/v1"
    
    struct Request {
        static let current = "/current.json"
        static let forecast = "/forecast.json"
    }
}
