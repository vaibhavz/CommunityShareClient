//
//  NearByBikeView.swift
//  BikeShare
//
//  Created by Joyal Serrao on 23/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import Foundation

protocol NearByBikeView: LocationIntrector {
    func nearByBikes(bikeInfo: [BikeRootModel])
    func failToFind()
    func getAllBike(bikeInfo: [BikeRootModel])

}

extension NearByBikeView {
    func nearByBikes(bikeInfo: [BikeRootModel]){}
    func getAllBike(bikeInfo: [BikeRootModel]){}
}
