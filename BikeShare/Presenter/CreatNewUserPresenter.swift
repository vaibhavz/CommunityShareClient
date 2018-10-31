//
//  CretaeNewUserPresenter.swift
//  BikeShare
//
//  Created by Joyal Serrao on 23/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import Foundation



class CreatNewUserPresenter  {
    init() {}
    weak fileprivate var view: CreatNewUserView?
    fileprivate var presntorLocation = LocationPresenter()
    private var currentUserLocation : Location?
    
    func attachView(_ view: CreatNewUserView) {
        self.view = view
        presntorLocation.attachIntrector(self)
        presntorLocation.currentLocation()
    }
    
    func detachView() {
        self.view  = nil
    }
    
    func getUserData(name:String?,color:String?,pin:String?)  {
        
        guard let userName = name, !(userName.isEmpty) else
        {
            self.view?.validationError(msg: "Enter user name")
            return
        }
        
        guard let pinLock = pin,!(pinLock.isEmpty)  else {
            self.view?.validationError(msg: "Lock code")
            return
        }
        guard let colorCycle = color  else {
            self.view?.validationError(msg: "Enter of the Cycle Color")
            return
        }
        
        guard let locationUser = currentUserLocation else {
            // self.view?.validationError(msg: "Go to Setting and Turn ON Location")
            self.view?.errorObtainLocation()
            return
        }
        
        let model = BikeRootModel(name: userName, color: colorCycle, location: locationUser, pin: pinLock)
        self.addBikeToSystem(data: model)
    }

    private func addBikeToSystem(data : BikeRootModel) {
        
        let payload =  data.payload()
        let header : NSDictionary = ["Content-Type" : "application/json"]
        
        _ = NetworkInterface.postRequest(.createNewBike, headers: header, params: nil, payload: payload , requestCompletionHander: { (flag, data, response, error, hash) -> (Void) in
            
            if (flag){
                let data =  String(data: data as! Data, encoding: .utf8)
                
                guard let  message = data  else{
                    self.view?.errorResponse()
                    return}
                self.view?.successfulCompletion(msg: message )
            }else{
                self.view?.errorResponse()
                
            }
            
        })
        
    }
    
}

extension CreatNewUserPresenter : LocationIntrector {
    
    func updateCurrentLocation(location: Location) {
        currentUserLocation = location
    }
    
    func currentLocationName(name: String) {
        self.view?.currentLocationName(name: name)
    }
    
    
}
