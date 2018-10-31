//
//  BikeNetworkError.swift
//  BikeShare
//
//  Created by Joyal Serrao on 21/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import Foundation


enum BikeNetworkError : Error {
    case httpStatus201 //2×× SUCCESS
    case httpStatus204 //No Content
    case httpStatus400 //4xx Client errors  Bad Request
    case httpStatus404 //4xx Client errors  Not Found
    case httpStatus410 //4xx Client errors
    case httpStatusUnknownError
}

enum DataErrors : Error {
    case invalidJSONData
    case dataParseError
    case noData
}
