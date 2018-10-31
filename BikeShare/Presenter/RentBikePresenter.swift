//
//  RentBikePresenter.swift
//  BikeShare
//
//  Created by Joyal Serrao on 25/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import Foundation


class RentBikePresenter  {
    
    
    weak fileprivate var userView: RentBikeView?
    fileprivate var presntorLocation = LocationPresenter()

    private let  bikeModel : BikeRootModel

    init(data : BikeRootModel) {
        bikeModel = data
    }
   
    
    func attachView(_ view: RentBikeView) {
        userView = view
        userView?.userDetail(data: bikeModel)
        userView?.rentBikeCurrentLocation(location: bikeModel.location)
        presntorLocation.attachIntrector(self)
        presntorLocation.currentDistanceCal(location:  bikeModel.location)
    }
    
     func detachView() {
        userView = nil
    }
    
    
    func rentBike(){
        
        if (UserDefaults.standard.isRented()){
            self.userView?.alreadyRented()
            return 
        }
        
        
        let id = bikeModel.id
        
        _ = NetworkInterface.putRequestWithID(.rentBike, extendIdUrl: id!, payload: nil, requestCompletionHander: { (flag, data, response, error, hash) -> (Void) in
            let data =  String(data: data as! Data, encoding: .utf8)
            if (flag){
                guard let  message = data  else{
                    self.userView?.errorResponse()
                    return
                }
                
                self.userView?.successfulCompletion(msg: message)
                UserDefaults.standard.setRented(value: true)
                UserDefaults.standard.synchronize()
            }
                else{
                self.userView?.errorResponse()
                }

         
        })
    }

}


extension RentBikePresenter :LocationIntrector {
    
    func nearByFromCurrentLocation(distance:String){
        userView?.nearByFromCurrentLocation(distance: distance)
    }


}

