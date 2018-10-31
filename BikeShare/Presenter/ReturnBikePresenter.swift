//
//  ReturnBikePresenter.swift
//  BikeShare
//
//  Created by Joyal Serrao on 26/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//
import Foundation

class ReturnBikePresenter  {
    
    weak fileprivate var userView: ReturnBikeView?
    fileprivate var presntorLocation = LocationPresenter()
    private let searchBikePresenter = SearchNearByPresenter()
    private var rentedBike : BikeRootModel?
    private var locationCurrent :  Location?
    init() {
        searchBikePresenter.attachView(self)
        searchBikePresenter.allBikeInfo()
    }
    
    func attachView(_ view: ReturnBikeView) {
        userView = view
    }
    
    func detachView() {
        userView = nil
    }
    
    func getLocationAfterEnble(){
        presntorLocation.verifyLocationServicesEnabled()
    }
    
    func returnBike() {
        
        guard let bike = rentedBike?.id  else {
            return
        }
        let header : NSDictionary = ["Content-Type" : "application/json"]
        _ = NetworkInterface.deleteRequest(.returnBike, headers: header, extendIdUrl: bike, params: [:], payload: [:], requestCompletionHander: {(flag, data, response, error, hash) -> (Void) in
            
            let data =  String(data: data as! Data, encoding: .utf8)
            guard let message = data  else {
                self.userView?.errorResponse()
                return
            }
            
            if (message.isEmpty){
                self.userView?.returnBikeComplited()
                UserDefaults.standard.setRented(value: false)
                UserDefaults.standard.synchronize()
            }else{
                self.userView?.successfulCompletion(msg: data!)
            }
        })
    }
    
    
//  private func updateCurrentLocation(bike: BikeRootModel){
//
//        let data = bike.payload()
//        let header : NSDictionary = ["Content-Type" : "application/json"]
//        let id  = bike.id! //"2"//UserDefaults.standard.getUserID()
//        _ = NetworkInterface.putRequestWithID(.updateBike, headers: header, extendIdUrl: id, params: nil, payload: data, requestCompletionHander: { (flag, data, response, error, hash) -> (Void) in
//            let data =  String(data: data as! Data, encoding: .utf8)
//            guard let message = data  else {
//               self.userView?.errorResponse()
//                return
//            }
//            self.userView?.successfulCompletion(msg: message)
//        })
//    }
    
    
    
    func updateBikeCurrentLocation(location: Location){
        
        if (location.latitude.isZero && location.longitude.isZero) {
            self.userView?.errorObtainLocation()
            return
        }
        
        guard var bike =  self.rentedBike else {return}
        bike.location = location

        let data = bike.payload()
        let header : NSDictionary = ["Content-Type" : "application/json"]
        let id  = bike.id! //"2"//UserDefaults.standard.getUserID()
        _ = NetworkInterface.putRequestWithID(.updateBike, headers: header, extendIdUrl: id, params: nil, payload: data, requestCompletionHander: { (flag, data, response, error, hash) -> (Void) in
            let data =  String(data: data as! Data, encoding: .utf8)
            guard let message = data  else {
                self.userView?.errorResponse()
                return
            }
            self.userView?.successfulCompletion(msg: message)
        })
        
    }
    
 
}

extension ReturnBikePresenter : LocationIntrector {
    
    func errorObtainLocation(){
        userView?.errorObtainLocation()
    }
    
    func updateCurrentLocation(location: Location){
        
        self.updateBikeCurrentLocation(location: location)

    }
}

extension ReturnBikePresenter : NearByBikeView {
   
    func failToFind() {

    }
   
    func getAllBike(bikeInfo: [BikeRootModel]){
        rentedBike = bikeInfo.filter(){$0.rented!}.first
        userView?.userDetail(data: rentedBike!)
        presntorLocation.attachIntrector(self) // update current location
    }

}

