//
//  NetworkInterfaceView.swift
//  BikeShare
//
//  Created by Joyal Serrao on 23/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//

import Foundation





protocol NetworkInterfaceView : class {
    func successfulCompletion(msg: String)
    func errorResponse()
}

protocol RentBikeView : NetworkInterfaceView,LocationIntrector {
    func userDetail(data : BikeRootModel)
    func rentBikeCurrentLocation(location : Location)
    func alreadyRented()
}

extension RentBikeView {
    func rentBikeCurrentLocation(location : Location){}
    func alreadyRented(){}

}
protocol CreatNewUserView : NetworkInterfaceView ,LocationIntrector{
    func validationError(msg : String)
}



protocol ReturnBikeView : RentBikeView{
    func returnBikeComplited()
}


