//
//  NearByBikePresenter.swift
//  BikeShare
//
//  Created by Joyal Serrao on 21/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import Foundation


struct LocationInfo {
    var latitude: Float
    var longitude: Float
    var radius: Float
}



class SearchNearByPresenter {

    weak fileprivate var userView: NearByBikeView?

    fileprivate var locationDetail: LocationInfo?
    fileprivate var presntorLocation = LocationPresenter()
    
    init() {
      
    }
   
    func attachView(_ view: NearByBikeView) {
        userView = view
        presntorLocation.attachIntrector(self)
    }

    func detachView() {
        userView = nil
    }

    func nearByAllBikes() {
        
        guard let location = locationDetail else {
            presntorLocation.currentLocation()
            self.userView?.nearByBikes(bikeInfo: [])
          //  self.userView?.errorObtainLocation()
            return
        }
        
        let info: NSDictionary = [
            "latitude": String(location.latitude),
            "longitude": String(location.longitude),
            "radius": String(location.radius)]

        _ = NetworkInterface.fetchJSON(.nearByBike, headers: nil, params: info, requestCompletionHander: { (flag, data, response, error, hash) -> (Void) in
            let decoder = JSONDecoder()
            do {
                let posts = try decoder.decode([BikeRootModel].self, from: data as! Data)
                let nonRentedBike = posts.filter(){$0.rented! == false}
                self.userView?.nearByBikes(bikeInfo: nonRentedBike)
            } catch _ as NSError {
                self.userView?.failToFind()
            }



        })

    }
    
    func reflashLocation(){
          presntorLocation.verifyLocationServicesEnabled()
    }

    func allBikeInfo() {
        
       
        _ = NetworkInterface.fetchJSON(.allBike, headers: nil, params: nil, requestCompletionHander: { (flag, data, response, error, hash) -> (Void) in
            let decoder = JSONDecoder()
            do {
                let posts = try decoder.decode([BikeRootModel].self, from: data as! Data)
                let nonRentedBike = posts.filter(){$0.rented! == false}
                self.userView?.nearByBikes(bikeInfo: nonRentedBike)
                self.userView?.getAllBike(bikeInfo: posts) // it used only for to get all bikes
            } catch _ as NSError {

                self.userView?.failToFind()
            }
        })
    }
    
    

}

extension SearchNearByPresenter : LocationIntrector {
  
    func updateCurrentLocation(location: Location) {
        locationDetail = LocationInfo(latitude: location.latitude, longitude: location.longitude, radius: 500)
    }
    
    func errorObtainLocation() {
        self.userView?.errorObtainLocation()
    }
    
}
